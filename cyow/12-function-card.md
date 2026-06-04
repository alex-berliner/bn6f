# 12 — `tools/function_card.py` (per-symbol summary)

## What it is

`./tools/function_card.py <SYMBOL>` prints a fixed one-screen report for a
function, aggregating what previously took ~5 greps + `.inc` reads:

- address, size, **alignment** (4- vs 2-aligned — drives trampoline PAD)
- manifest membership (IN MANIFEST?)
- source file + line range of the `thumb_func_start/end` block
- baseline call/exit counts from `build/track_hits.txt` (via `make track`),
  flagged paired/UNPAIRED
- ambient-reg hints (`r10` → Toolkit\*, `r5` → sprite/chatbox\*)
- `⚠ bx rN` computed-branch warning
- `bl` target classification: converted / BIOS (`SWI_`) / **UNCONVERTED**
- callsite count + **flag-dep caller count**
- inline pool labels
- optional inline Ghidra decomp from `build/ghidra-decomp/<sym>.c`

## Honest read

This is the **read-side twin of the candidate picker** (Feature 1, which
we deleted to rebuild as one gate-enforcing selector). Its per-symbol
analysis — flag-dep detection, `bx`/vtable hints, converted-callee
classification, alignment-for-PAD — is **exactly** what the rebuilt
Feature 1 selector and the Feature 5 bulk stubber must compute. The logic
is worth keeping; the *standalone live query tool* is not, because the
06c/07b verdict already calls for a **batch build-metadata artifact** that
precomputes per-function facts (call counts, etc.) for the whole ROM.

## Verdict

**SUBSUME into the batch metadata artifact.** No standalone `card <sym>`
query tool survives. Instead:

- one shared analysis backend computes these per-function facts;
- the **batch build artifact** (06c/07b) persists them for the whole ROM
  in one pass;
- the rebuilt **Feature 1 selector** and the **Feature 5 stubber** read
  from that same backend/artifact rather than re-deriving.

So `function_card.py` is retired as a tool, but its field set becomes the
schema of the batch artifact. Ghidra display (Feature 14) rides along as
an optional, non-authoritative column.

---
_Last updated: 2026-06-04 13:43:19 -0400_
