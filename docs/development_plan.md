# Development Plan — bn6f decomp (v2)

v1 was derived from the feature-by-feature review (shelved at `e6bb4969:cyow/`).
v2 revises it after the 2026-07-12 repo audit and four decisions made that day.
`[F#]` tags point to the original review verdicts; `[D#]` tags point to the
decisions below.

Cadence: **small and slow.** Each brick is its own commit with a single
verifiable "done", and we stop for review after each.

---

## Decisions (2026-07-12)

- **[D1] Two-track oracle.** v1's "full machine-state byte parity" cannot
  survive relocation (moved return addresses in live frames, stored code
  pointers, dead-stack residue below SP). So: **strict masked byte-parity**
  is the oracle while C sits behind trampolines at original entry points
  (scaffolding era); **per-frame observable hash** — VRAM + OAM + palettes +
  display/sound registers over bk2 fixtures — is the permanent oracle
  (pointer-free, survives relocation). Both run together during the overlap;
  the strict oracle may retire only when the frame-hash oracle catches every
  divergence class the strict one has caught. End-state acceptance is the
  **shuffle test**: randomize C link order (and shift the C region), rebuild,
  all fixtures pass — that is the operational definition of "relocatable".
  Note: frame-hash of compositor *inputs* is not the pixel hashing rejected
  by [F6d]; it is stricter (catches off-screen VRAM/OAM corruption) and
  still address-free.
- **[D2] Modern GCC (arm-none-eabi), agbcc retired.** Matching codegen was
  only needed to keep exact parity through relocation — which [D1] shows is
  unreachable anyway. Audit go/no-go passed: the game never reads timer
  counters into gameplay state (the one code hit, `libs.s:22134`, is a
  `SWI_CpuSet` length constant, not a timer address; only VBlank fires
  during gameplay, IE=0x2005). Kills the agbcc LR-bit epilogue bug class,
  the wrapper zoo, and the r10 fork question; modders get a maintained
  toolchain. Tracked residual risk: mid-frame raster/HDMA effects are
  timing-sensitive — enumerate and pin/test those sites (Phase 1 mask work).
- **[D3] Placement: grow the ROM to 16 MB; all C lives in the extension
  permanently.** No relocate-into-reclaimed-space, no compaction, no
  inline-into-original-slots — v1 Phase 5's scheme existed only to serve
  exact parity. Trampolines sit at original entry points until the last ASM
  caller of a symbol is converted, then die naturally. (Prototype ld script
  exists on the pre-reset worktree branches, e.g. `worktree-agent-*`.)
- **[D4] Validation mechanics: snapshot-corpus first, replay second.**
  During fixture replay, harvest full-state snapshots at every call boundary,
  keyed by symbol. Validating a conversion = restore the symbol's harvested
  entry states, run original vs C to return, masked-compare — hundreds of
  real cases in seconds, parallelizable across symbols. Whole-fixture
  frame-hash replay is the nightly/combined-build gate, not the per-function
  loop. Cold (never-executed) symbols get a synthetic-precondition mode
  later (Phase 4); the coverage report says exactly which those are.

## Principles (non-negotiable)

- **Errors impossible by construction, not scanned for.** Every safety gate
  is enforced in code, never as prose/checklist. [F1, F4]
- **Never trust a check you haven't watched fail.** Every oracle and every
  mask ships with seeded faults it must catch; the mutation suite stays in
  CI forever. A mask with no adjacent rent-paying mutant is a blind spot.
  [new, from D1 discussion]
- **Real BIOS always; never HLE.** The harness refuses to run without a
  checksum-verified official BIOS and says so explicitly. [F6e, F7a, F7c]
- **Isolation.** Single-function differential at call-boundary cadence — not
  whole-ROM replay in the inner loop. [F6a, D4]
- **The pristine ASM build stays SHA-exact** (`make all`, pure ASM, no C
  toolchain involved). C is a separate overlay build (`make decompile`).
- **Single `rom.o`** — no object split (protects the SHA build). [F5]
- **Throughput is a design requirement.** 2,751 functions: per-function
  validation must cost seconds, run in parallel, and gate machine-generated
  drafts — the harness is the reviewer of record, humans review greens.
  [audit: pace is the #1 risk]
- **End goal: fully relocatable C**, operationally defined by the shuffle
  test [D1]. Typed struct access from the first conversion (no raw-offset
  casts to retire later).

## Phase 0 — hygiene + harness substrate

- **P0 — publish & guard the baseline.** Push `master` (70 commits are
  local-only). Add CI: `make all` + `sha1sum -c bn6f.sha1` + `cargo test`
  on every push. *Done:* remote up to date, CI green.
- **B0 — substrate builds & loads. ✓ DONE** (`9663d4d9`) — loads ROM + real
  BIOS, reads title off the bus. Retrofit: turn its claims into `cargo
  test`s (title == `MEGAMAN6_FXX`; BIOS file checksum-verified, path from
  env var with the hardcoded default removed; wrong/absent BIOS ⇒ explicit
  refusal). [F7e, F6e]
- **B1 — determinism + snapshot fidelity.** Bind `mgba/core/serialize.h`
  (wrapper.h + build.rs), add frame stepping + full-state serialize + hash.
  *Done (as tests):* same N-frame run twice ⇒ identical hash;
  snapshot→restore→continue ⇒ identical hash; and a sensitivity self-test:
  N vs N+1 frames ⇒ different hash. [F6a]
- **B2 — execution control.** Stop the core exactly at a target PC (entry)
  and at its matching return. *Done (as tests):* break at a known function's
  entry and return.
- **B3 — differential atom (identity + first masks).** snapshot pre → run to
  return → hash A; restore → run again → hash B; assert A==B. Then the first
  masked compare: mask spec v0 = cycle/timer counters + IWRAM below SP,
  each mask entry documented and paired with a seeded fault it still
  catches (mutation suite v0: poke a register / skip a store post-restore ⇒
  compare must fail). [F6a, D1]

## Phase 1 — fixtures, coverage, harvesting (the shared truth)

- **Fixtures:** record real-BIOS bk2s in BizHawk (`make bizhawk-dll`; same
  pinned mgba core as the harness) covering boot, menus, overworld, battle
  variety, shops, net areas. Harness replays each bk2 and its frame-hash
  trace is stored as a build artifact. *Done:* replay is deterministic and
  BizHawk-consistent. [F7a-d]
- **Frame-hash oracle v0:** per-frame hash of VRAM/OAM/PAL + display/sound
  registers during replay; plus its own mutation suite (corrupt a tile /
  an OAM entry / a palette color ⇒ trace must differ). [D1]
- **Call-boundary harvester:** on replay, snapshot at every function
  entry/return; per-symbol corpus on disk. The ⭐ profiler falls out of the
  same instrumentation: call counts, per-`(symbol × fixture)` coverage,
  ranked hot list, and the cold-function list (no corpus ⇒ Phase 4
  synthetic mode). [⭐, F6c, F7b, F12, D4]
- **Candidate selector** — one canonical tool, every gate in code: leaf
  (mod BIOS/converted), no flag-dependent callers, alignment, corpus size
  ≥ threshold. Address-taken symbols (the `.word sym+1` set, ~1,012 fns)
  are *deferred, not refused*: they unlock after the P2 ground-rules brick
  passes. Inputs mined from `calltree_db` + `hard_pointer_finder` (both
  already in `tools/misc_scripts/`). [F1, F2]
- **Struct header generator:** `src/asm/include/structs/*.inc` → generated
  `src/c/decomp_structs.h` via the DSL's offset-emitting mode, so
  conversion #1 already writes `toolkit->CurFramePtr`-style access.

## Phase 2 — conversion machinery (safe by construction)

- **JSON manifest** — `{asm_symbol, c_file, pad, wrapper_kind, address,
  enabled}`; Makefile derives `--defsym` + C file list from it. [F4]
- **Bulk stubber (one-time):** wrap every function in the
  `.ifndef DECOMP_<sym>` / trampoline skeleton with alignment-aware PAD,
  pool-flush handling, multi-entry gating; flag (don't silently wrap)
  flag-dependent-caller and address-taken symbols. Reimplement fresh — do
  not lift `wrap_decomp.py` [F9]. *Done:* `make all` still SHA-exact with
  all stubs off. After this, a conversion = add C file + flip `enabled`;
  never hand-edit `.s`. [F5]
- **`make decompile` overlay build:** arm-none-eabi-gcc, 16 MB ld script
  with a permanent `.c_code` extension region [D3] (mine the worktree
  prototype for the script, not the workflow).
- **GCC ground-rules brick** (replaces v1 Phase 4's agbcc gates): pick and
  freeze flags (`-mthumb -march=armv4t -Os`, interwork on/off, `-ffixed-r10`
  + `register … asm("r10")` for the ambient pointer [F11]) by running two
  demonstrators under the harness: a vtable-dispatched callee (the
  `mov lr,pc; bx rN` caller pattern that broke agbcc epilogues) and an
  r10-consumer. *Done:* both validate via D4 corpus; address-taken class
  unlocks in the selector.
- **Validator:** per-function corpus check (D4) + combined-build fixture
  replay; `patch_result.log`: `symbol | verdict | suspected_reason`;
  mutation suite runs in CI so the validator itself stays proven. [F6b,
  F8c]

## Phase 3 — first validated conversions (end to end)

- One trivial leaf through the whole pipeline; then a batch of ~10
  including (post-ground-rules) one address-taken function; validate both
  isolated per-patch and the combined build. [F6b]
- **Milestone: first validated conversion lands by 2026-08-15.** The
  tooling runway (P0→here) is capped by this date — cut scope, not the
  date, if it slips. [audit: 5½-week stall; runway risk]
- Byproduct deliverable: the manifest + stubs + extension region *is* a
  code-injection modding framework. Document it as such once the first
  batch lands — standalone community value long before full C.

## Phase 4 — scale machinery

- **Machine-drafted conversions:** Ghidra/LLM drafts (non-authoritative
  aids [F14]) gated by the D4 validator; humans review green diffs only.
  The multi-agent layer returns here, as promised post-F4/F5. [F10]
- **Synthetic-precondition mode** for the cold list: constructed register/
  memory preconditions, differential-fuzz original vs C. Extends coverage
  past what fixtures can reach.
- **Struct discovery:** wire `MemoryAccessProtocol` + `StructPadder` onto
  harness state traces (replacing the old VBA-rr Lua input) → grow
  `decomp_structs.h`. [tools review]
- Nightly: all fixtures, combined build, frame-hash traces vs baseline.

## Phase 5 — retire the scaffolding

- Trampolines die per-symbol as their last ASM caller converts (manifest
  tracks caller counts; stub dropped automatically). No relocation pass
  exists [D3].
- **Oracle handover:** strict masked parity retires only when the
  frame-hash oracle demonstrably catches every mutant class strict parity
  ever caught (the overlap ledger from D1). 
- **Shuffle test goes live and permanent in CI** [D1].
- **IWRAM-resident class** (named explicitly; was a gap in v1): functions
  copied to `0x03xxxxxx` at runtime, incl. the IRQ install path /
  dispatcher via `0x03007FFC` — convert with fixed IWRAM placement first;
  make relocatable last. [F2]

## Phase 6 — full C end state

All code paths C; original 8 MB region reduces to data/assets; ASM tree
retained only as reference. Modern-toolchain-only build; INSTALL/CONTRIBUTE
rewritten (they still describe the pre-decomp world); modding framework
documented. Post-goal refactor pass retires any remaining staging idioms.

## Retired / not doing

agbcc + agbcc-src (remove from `setup-toolchain` once the P2 ground-rules
brick passes) [D2]; v1 Phase 5 relocation/compaction and hot-slot inlining
[D3]; `DECOMP_VTABLE_WRAPPER`/LR-bit wrapper class (superseded by the GCC
ground-rules brick) [D2]; `wrap_decomp.py` [F9]; `validate_asm.py` static
oracle [F13]; pixel hashing of composited output [F6d — D1's frame-hash of
compositor inputs is a different, stricter thing]; IDA-era tools.

## Immediate next step

**P0 — publish & guard the baseline** (push + CI), then **B0 retrofit +
B1** in `tools/harness` as `cargo test`s.

---
_Last updated: 2026-07-12 12:37:04 -0400_
