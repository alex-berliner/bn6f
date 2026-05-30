# CYOW TODO — decomp toolkit changes

Actions decided during the feature-by-feature review. Nothing here is
committed automatically; these are the agreed changes to make.

## ⭐ Hotpath identification (cross-cutting, high priority)

Surfaced during Feature 2. We cannot currently answer "which functions
are hotpath / drift-sensitive?" because everything is named `sub_XXXX`
and we have no runtime call-frequency data since the `bn6f-track`
harness was removed.

This blocks the relocation strategy (which functions to inline-in-place),
informs candidate selection (Feature 1's coverage gate), and tells us
which conversions are even *capable* of causing VBlank drift.

- [ ] Build a hotpath/coverage profiler: per-function call counts (and
      ideally cycles) over the bk2 fixtures, under libmgba. This is what
      the deleted tracker did — likely rebuild a lean version on top of
      `bn6f-validate`'s existing libmgba harness rather than a separate tool.
- [ ] Output a ranked "hottest functions" list usable by: relocation
      planning, candidate selection, and drift-risk triage.
- [ ] Cross-reference with the pin census so each hot function is tagged
      pinned/relocatable (drives the inline-vs-relocate decision).

## Feature 1 — Candidate selection → REPLACE

**Verdict: both existing systems are bad. Delete both, build one new one.**

### Done
- [x] Delete `tools/find_decomp_candidates.py` — enforced the right
      safety gates but got stranded when the `bn6f-track` harness was
      removed; its coverage gate reads `build/track_hits.txt` (output of
      the now-deleted `make track`) and it points at a stale
      `bn6f_orig.elf` path. Effectively dead.
- [x] Delete `.claude/commands/decomp-step.md` — the shadow selector
      (awk-by-line-count + a prose checklist of manual greps). Weaker
      than the python tool it routed around, and duplicated selection
      logic as un-enforced prose.

### To build — NEW candidate-selection system
- [ ] Design + implement a single canonical "what to decomp next" tool.
      Requirements gathered so far:
  - One source of truth (no shadow awk path, no manual-grep checklist).
  - Enforce **in code** every safety gate, not as prose:
    - leaf modulo BIOS + already-converted (no `bx rN`, no unconverted `bl`)
    - no flag-dependent callers (`beq/bne` after the `bl`)
    - **4-byte alignment** (address ends 0/4/8/C) — was manual before
    - **no vtable membership** (`.word <sym>` / `.word <sym>+1`) — was manual before
    - no dropped multi-return (r1 used by callers) — was manual before
  - Point at the **current** build artifact path (`build/bn6f_orig.elf`).
  - Coverage signal: decide replacement for the removed `track_hits.txt`
    (derive from the bk2 pixel-hash validator, or drop the coverage gate).
  - Ranking: keep call-count leverage ordering.
  - Decide where it lives (a `tools/` script the loop calls directly,
    vs. baked into a slimmer skill).

### Open questions for the new tool
- [ ] Do we still want a runtime-coverage gate at all, now that the
      tracker is gone? If yes, what produces the data?
- [ ] Should the loop skill be rebuilt too, or just call the new tool?

## Feature 2 — Trampoline gating → KEEP + new relocation strategy

**Verdict: keep the trampoline mechanism (necessary evil). But pursue
relocation to kill the VBlank-drift root cause for hotpath functions.**

### Relocation strategy (new work)

- [x] **Relocatability census** (done 2026-05-29; verified across
      asm+data+maps): **1740 / 2664 (65%) relocatable**, 924 (35%)
      pinned by `.word`. Scanning the data/maps pointer tables only added
      +41 pins vs asm-only, so the strategy works with the grain of the
      binary. Manifest 534: 493 relocatable (92%), 41 pinned. See cyow/02
      for the full table.
- [ ] Design: relocate the relocatable 65% to the **bottom of the ROM**,
      freeing contiguous space in the original region.
- [ ] Use reclaimed space to inline **hotpath** functions' full C bodies
      in-place (no trampoline → no per-call drift).
- [ ] Constraint: the slots we reclaim near a hotpath entry must hold
      relocatable code. The pinned VBlank entry can't move, but with 65%
      density its neighbors usually can.
- [ ] **Raw-address safety check before moving any "relocatable" symbol.**
      The census flags a function relocatable when no `.word <sym>`
      references its *label*. But an absolute address can be referenced
      *numerically* — `ldr rN, =0x08XXXXXX`, `.word 0x08XXXXXX`, computed
      offsets from another symbol, mid-function entry points — without
      ever naming the symbol. A symbol can be documented in some places
      and still have an undocumented raw-address reference elsewhere.
      Before relocating a symbol, grep the ROM for its **resolved
      absolute address** (and nearby addresses, for mid-function refs) in
      raw numeric form across asm + data + maps. Any hit = NOT safe to
      move (or the raw ref must be fixed up too). This is a hard gate, not
      advisory — getting it wrong silently corrupts at runtime.
      Implication: census "relocatable" is *necessary but not sufficient*;
      it's a candidate filter, and this numeric check is the real gate.

### IRQs: split the subsystem — mechanism EARLY, hot bodies LATE (revised 2026-05-29)

Earlier framing was "leave all IRQs for the end." Refined: the IRQ
subsystem is **two different things** with opposite scheduling.

**Terminology (clarified 2026-05-29):** the IRQ "vtable" is *data* —
pointer words. We do NOT rewrite the table as code; we rewrite the
**functions it points at**. In-place trampoline conversion leaves the
table untouched (the pointer still resolves to the same slot); the table
only needs a mechanical pointer update if a target is *relocated*. For
the RAM dispatch table, entries are written at runtime by populator
*code*, so "changing the table" = changing the populator (code), not
editing a static table.

**IRQ structure (verified 2026-05-29 — earlier draft had fabricated
symbols `sub_8000208` / `0x3007FF4`; removed):**
- `start.s::_start` installs the GBA IRQ handler pointer at `0x03007FFC`
  ← `sub_3005B00` (single pointer word; `off_80001FC`/`off_800020C`).
- `sub_3005B00` is the dispatcher — an **IWRAM routine copied from ROM at
  boot**; its real body lives in `asm/asm38.s` (ARM). Its internal
  RAM-table address is NOT yet mapped (inside that body) — map before
  relying on this.
- Populator `_SetInterruptCallback` also in `asm/asm38.s`; the thumb
  shim `SetInterruptCallback` is in `start.s` and uses `mov lr, pc; bx
  rN` → LR-bit hazard ([[decomp_lr_bit_bx_bug]]).
- Callers of `SetInterruptCallback` (the registrants / real dependents):
  `asm/asm00_0.s`, `asm/asm38.s`, `asm/main.s`, `asm/start.s`.

**(a) Mechanism FUNCTIONS (install path, dispatcher, populator,
registrants) → DE-RISK EARLY.** Structural, touched once. The risk to
avoid: deferring the *whole* IRQ subsystem to the very end, then finding
its tendrils reach boot / savestate / soft-reset with no slack to react.
Prove the mechanism is safe to rework while there's still room.

- [ ] Map every dependent: who writes `0x03007FFC`, what RAM address the
      dispatcher (`sub_3005B00`, asm38.s) uses for its table, every
      caller of `SetInterruptCallback`. (Boot, savestate, soft-reset =
      prime suspects.)
- [ ] Convert the mechanism **functions** early — `start.s` install path,
      `asm38.s` dispatcher/populator, the registrant callers — not to
      rush, but to learn the dependents and prove the mechanism is safe
      to rework. BEFORE the relocation push so a surprise is cheap, not
      terminal. (The table data itself isn't "converted" — it's pointers.)

**(b) Hot handler bodies (per-frame VBlank work) → LEAVE FOR END.**
Worst-case intersection: **pinned** (vector/RAM table holds their
address) AND the most **drift-sensitive** code ([[trampoline_cycle_drift]],
[[irq_inventory_bn6f]] — VBlank is the only gameplay IRQ). Only doable
well as inline-C-at-fixed-slot-no-trampoline → needs relocation infra
first. Convert now → drift → revert → redo.

- [ ] Treat the **hot IRQ bodies as a unit** (handler + hot callees),
      converted last, after relocation machinery exists. Converting a
      callee on the path early reintroduces the same drift.

### Open questions

- [ ] Does the linker script (`ld_script_decompile.ld`) already give us a
      relocation target region, or does that need new sections?

## Feature 3 — Wrapper macros → NO RESOLUTION, demonstrator required

**Verdict deferred.** Discussion raised the possibility that an agbcc
epilogue change (emit mode-preserving `pop {pc}`/`mov pc, lr` instead of
interworking `bx lr`) could eliminate the `DECOMP_VTABLE_WRAPPER` class
entirely, optionally plus a fault-aware build linter. This is unverified
and does NOT escape the methodology-revalidation step. No decision until
a demonstrator proves the premise.

### Build the epilogue demonstrator (gate before any agbcc decision)

- [ ] Pick one vtable-dispatched function (e.g. the `sub_81231E0` class,
      dispatched via `off_81211D0` in `asm/asm32.s`).
- [ ] Produce **two binaries** of the same conversion:
      - **OFF**: plain agbcc `bx lr` epilogue (no VTABLE wrapper).
      - **ON**: mode-preserving epilogue (`pop {pc}`/`mov pc, lr`).
- [ ] With OFF, **capture the actual failure** — validator diff,
      first_diff_frame, wrong pixels, or crash. Not "it should fail" —
      the real captured error, side by side.
- [ ] With ON, show it passes.
- [ ] Outcome gates the decision:
      - reproduces OFF + fixed ON → epilogue direction proven; revisit
        options A/B/C and the [[decomp_no_agbcc_fork]] memory.
      - does not reproduce → premise wrong, wrappers stay; close it out.

### Claims to re-verify if the demonstrator passes (do NOT trust on assertion)

- [ ] That changing agbcc's epilogue can't affect the SHA-exact `make
      all` (claim: that path is pure ASM, agbcc only runs in
      `make decompile`). Verify empirically (`make all` still matches).
- [ ] Whether an opt-in function attribute is enough, or a global codegen
      change is needed.
- [ ] Whether the fault-aware linter (option B) can reuse the pin census
      and live in external tooling (no agbcc fork).

## Feature 4 — Manifest/build flavors → RESTRUCTURE (JSON + one-time stub)

Two conflated problems, solved separately. **Drift should be impossible
by construction, not scanned for.**

**A) symbol tracking → JSON manifest** with a per-record enabled flag
(partial patch sets, no file moves/deletes).

- [ ] Design JSON schema: `{asm_symbol, c_file, pad, wrapper_kind,
      address, enabled}` per record.
- [ ] Migrate the 534 active `decomp_manifest.txt` entries into it.
- [ ] Rewire the Makefile to derive `--defsym` + c-ofile list from the
      JSON instead of the flat file.

**B) mechanical replacement → keep `.ifndef`, stub ALL gates once.**
Keep the single `rom.o` (no object split — protects SHA-exact build;
weak-symbol override is impossible in one translation unit).

- [ ] One-time script wraps every `thumb_func_start` function in the
      `.ifndef DECOMP_<sym> / orig / .else / decomp_trampoline
      <sym>_c,<pad> / .endif` skeleton.
- [ ] Auto-compute PAD from the ELF in that script (kills manual-pad
      footgun tree-wide).
- [ ] Handle the 1380 embedded-pool functions (body-extent parser, not
      regex); handle the `.pool` flush hazard; 5 multi-entry funcs by hand.
- [ ] Verify `make all` still SHA-matches after the bulk stub (whole
      safety claim rests on `.else` being inert when undefined).
- [ ] After this: per-conversion = add C file + flip JSON enabled. Never
      hand-edit `.s` again.

**Left as-is:** mtime/stash force-rebuild workaround; fixed `.c_code`
region length.

---
_Last updated: 2026-05-30 11:34:09 -0400_
