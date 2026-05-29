# CYOW TODO — decomp toolkit changes

Actions decided during the feature-by-feature review. Nothing here is
committed automatically; these are the agreed changes to make.

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

---
_Last updated: 2026-05-29 13:07:50 -0400_
