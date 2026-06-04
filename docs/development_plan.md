# Development Plan — bn6f decomp (from first principles)

Derived from the feature-by-feature review (shelved at `e6bb4969:cyow/`,
restore with `git checkout e6bb4969 -- cyow`). This doc is self-contained;
`[F#]` tags point back to the originating verdict.

Cadence: **small and slow.** Each brick is its own commit with a single
verifiable "done", and we stop for review after each. Phase 0 first, in order.

---

## Principles (non-negotiable, from the review)

- **Errors impossible by construction, not scanned for.** Every safety gate
  is enforced in code, never as prose/checklist. [F1, F4]
- **Oracle = full machine-state byte parity**, not pixel hashing. Subsumes
  audio. [F6a, F6d]
- **Real BIOS always; never HLE.** The harness refuses non-real-BIOS
  replays and fails them with that explicit reason. [F6e, F7a, F7c]
- **Isolation.** Single-function *differential* (pinpoint the diverging
  function), at per-call-boundary cadence — not whole-ROM replay. [F6a]
- **The pristine ASM build stays SHA-exact** (`make all`, pure ASM, no
  agbcc). C is a *separate* overlay build. [F-agbcc, this session]
- **Single `rom.o`** — no object split (protects the SHA build; weak-symbol
  override is impossible in one TU). [F5]
- **End goal: fully relocatable C.** Trampolines are staging only;
  relocation is what kills VBlank drift at the root. [F2]

---

## Phase 0 — Harness substrate (pure; no conversions yet)

The foundation everything diffs against. No C, no manifest, no risk.

- **B0 — substrate builds & loads.** Restore `tools/libmgba` [F7e], get
  `tools/harness` compiling, run load-real-BIOS+ROM+reset. *Done:* prints
  the correct ROM title under real BIOS.
- **B1 — determinism + snapshot fidelity.** Run N frames, serialize full
  state, hash. Assert (a) same run twice → identical hash; (b)
  snapshot→restore→continue → identical hash. *Done:* both hold. [F6a]
- **B2 — execution control.** Stop the core exactly at a target PC (entry)
  and at its matching return. *Done:* break at a known function's entry,
  stop at its return.
- **B3 — differential atom (identity).** snapshot pre → run to return →
  hash A; restore → run again → hash B; assert A==B. No C yet — proves the
  diff machinery itself. *Done:* identity differential passes. [F6a]

## Phase 1 — Coverage, selection & relocation data (the shared truth)

- **Fixtures re-recorded against real BIOS** (SkipBios off), savestates
  captured from real-BIOS runs; harness gate refuses HLE replays. [F6e,
  F7a, F7c, F7d]
- **Profiler** (the ⭐ cross-cutting item): per-function call counts over
  the bk2 fixtures under libmgba → ranked "hottest functions" list +
  per-`(symbol × bk2)` coverage. Emitted as a generated `build/` artifact,
  merged with fixture metadata. Absorbs `function_card`'s field set. [⭐,
  F6c, F7b, F12]
- **Candidate selector** — one canonical tool, every gate in code: leaf
  (mod BIOS/converted), no flag-dependent callers, 4-byte alignment, no
  vtable (`.word <sym>`) membership, no dropped multi-return. Ranked by
  call count (from profiler), coverage signal from profiler. [F1]
- **Relocatability census + raw-address safety gate.** Rebuild the census
  (was 1740/2664 ≈ 65% relocatable) and the hard gate: before moving a
  symbol, grep the ROM for its *resolved absolute address* in raw numeric
  form — any hit = not safe. Mine `calltree_db` (call graph incl. `bx r0`
  dispatch) and `hard_pointer_finder` for this. [F2]

## Phase 2 — Conversion machinery (safe by construction)

- **JSON manifest** — `{asm_symbol, c_file, pad, wrapper_kind, address,
  enabled}` per record; `enabled` = per-symbol on/off without moving
  files. Makefile derives `--defsym` + c-ofile list from it. [F4]
- **Bulk stubber (one-time).** Wrap every function in the
  `.ifndef DECOMP_<sym>/.else/decomp_trampoline/.endif` skeleton, with:
  auto alignment-aware PAD (8/10/14/16, accounting for `.pool` balign),
  shared-pool-flush handling, multi-entry tail-only gating, and
  **refuse/flag both flag-dependent callers AND vtable membership**
  (reimplement fresh — do not lift `wrap_decomp.py`). Keep single
  `rom.o`; verify `make all` still SHA-matches. After this, a conversion =
  add C file + flip JSON `enabled`; never hand-edit `.s`. [F5, F9]
- **C-overlay build target** (`make decompile`) invoking agbcc, separate
  from the SHA-exact `make all`.
- **Canary folded into the validator**; delete `canary.sh` (unify the
  harness). Keep a byte_fill-class regression. [F8c, F8e]

## Phase 3 — First validated conversion (end to end)

- Convert one trivial leaf function (passes the selector) → `src/c/`.
- Differential-validate across every covered call site; run **both**
  isolated per-patch AND the combined all-patch build. [F6b]
- `patch_result.log`: `id_symbol | verdict | suspected_reason`; skip
  uncalled `(symbol × bk2)` cases. [F6b, F6c]
- Videos on-demand only (flag off by default, small files). [F6h]

## Phase 4 — Gated investigations (decision points; don't block Phase 0–3)

- **agbcc epilogue demonstrator.** One vtable-dispatched function, two
  binaries: OFF (plain `bx lr`) capturing the *real* failure, ON
  (mode-preserving epilogue) passing. Outcome gates whether the
  `DECOMP_VTABLE_WRAPPER` class can die and the agbcc option-1-vs-3 call.
  No agbcc decision until this proves the premise. [F3]
- **agbcc file-scope global register variable** for r10/r5 ambient
  pointers (per-file, not blanket `-ffixed-r10`); prove via full
  `make decompile` + validate on one converted file. Unlocks typed
  `gToolkit->Field` access. [F11]
- **Struct discovery:** wire `MemoryAccessProtocol` + `StructPadder` onto
  the harness's own state traces (replacing the old VBA-rr Lua input) →
  build out `src/c/decomp_structs.h`. [tools review]

## Phase 5 — Relocation (kills VBlank drift; enables the end goal)

- Define a linker region for relocated code (does
  `ld_script_decompile.ld` give one, or new sections?). [F2 open]
- Relocate the relocatable ~65% to the bottom of the ROM (raw-address
  gate on each), freeing contiguous space in the original region. [F2]
- Inline **hotpath** C bodies into reclaimed slots — no trampoline → no
  per-call drift → full-state parity achievable on hot frames. [F2, F6a]
- **IRQ split:** mechanism functions early (map every dependent of
  `0x03007FFC` / `sub_3005B00` / `SetInterruptCallback`; convert install
  path + dispatcher + populator + registrants to de-risk); hot VBlank
  handler bodies **last**, after relocation infra exists. [F2]

## Phase 6 — Scale toward full C

Batch conversions through the now-safe pipeline; keep the combined-build
parity green; march toward the no-ASM end state.

---

## Retired / not doing

`wrap_decomp.py` [F9], `validate_asm.py` static oracle (runtime is ground
truth) [F13], multi-agent layer (revisit post-F4/F5) [F10], Ghidra as
anything but a non-authoritative aid [F14]; IDA-era tools deleted.

## Immediate next step

**B0.** Needs `tools/libmgba` restored first
(`git checkout e6bb4969 -- tools/libmgba`), then `tools/harness` builds and
runs the load-BIOS+ROM scaffold.

---
_Last updated: 2026-06-04 15:44:00 -0400_
