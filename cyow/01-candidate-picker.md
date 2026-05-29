# 01 — Candidate selection (what to decomp next)

## What it is
The machinery that decides *which ASM function you convert next*. Two
overlapping mechanisms exist:

1. **`tools/find_decomp_candidates.py`** — the "real" filter. Emits a
   ranked table of leaf-ish functions that look safe to auto-convert.
2. **An inline awk one-liner** in the `/decomp-step` skill that just
   lists functions by ASM line-count, plus a checklist of manual greps
   (4-aligned address, no vtable `.word`, no multi-return).

## How `find_decomp_candidates.py` works today
Single pass over `asm/*.s` + a cached `objdump -t bn6f_orig.elf`. A
symbol survives only if ALL hold:
- public `thumb_func_start`, size ≥ 8 bytes, not in the manifest
- **leaf modulo BIOS+converted**: every `bl` target is either a known
  `SWI_*` or already converted; no `bx rN` in the body
- **no flag-dependent callers**: no `beq/bne/...` on the line right
  after any `bl <sym>`
- **demo coverage**: appears in the tracker baseline with `calls ≥ 1`
  and `calls == exits` (cleanly paired)

Output is sorted by descending call count: `sym  size  calls  callsites`.

## Strengths
- The hard safety gates the `/decomp-step` prose tells humans to check
  *by hand* (leaf, no bx, no flag-dep caller) are **actually enforced
  in code** here. That's much better than a checklist.
- objdump output is mtime-cached → re-runs are instant.
- Ranking by runtime call-count is a real leverage signal.

## Weaknesses / open questions
- **Stale dependency**: the demo-coverage gate reads
  `build/track_hits.txt`, described as "produced by `make track`" — but
  `make track` was removed (Makefile: *"harness bn6f-track removed"*).
  If that baseline is missing/stale, the `calls == exits` check
  silently filters out **every** candidate (or runs on stale data).
  This is the big one: the picker may be quietly broken.
- **Path drift**: it points at `bn6f_orig.elf` at repo root, but the
  build now produces `build/bn6f_orig.elf`. Likely never finds the ELF
  → empty symbol table → no candidates.
- **Two sources of truth**: the python filter and the skill's awk
  one-liner + manual greps don't obviously agree. Which is canonical?
- It does **not** check the two gates `/decomp-step` calls out as the
  worst footguns: 4-byte alignment and vtable membership (`.word
  <sym>`). Those stay manual.
- No dependency ordering toward already-converted callees.

## Verdict

**BAD — both systems deleted, rebuild one new.** (2026-05-29)

Both `tools/find_decomp_candidates.py` and `.claude/commands/decomp-step.md`
were removed. The python filter had the right idea (enforce safety gates
in code, rank by call-count leverage) but got stranded when the
`bn6f-track` harness was torn out, leaving its coverage gate and ELF path
pointing at things that no longer exist. The `/decomp-step` skill was the
weaker shadow selector (awk-by-line-count + manual-grep prose) and
duplicated selection logic the loop had already routed around.

Decision: delete both, build a single canonical selector that enforces
*all* gates (including the previously-manual 4-align / vtable / multi-return
checks) against the current build artifacts. See [todo.md](todo.md).

---
_Last updated: 2026-05-29 13:09:10 -0400_
