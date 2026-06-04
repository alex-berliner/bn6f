# 14 — Ghidra pre-pass (`build/ghidra-decomp/<sym>.c` cache)

## What it is

A per-symbol cache of Ghidra's decompiler output, populated offline and
shown inline by `function_card.py` as a "first-pass aid." Not wired into
any build or oracle — purely an understanding aid for the human/agent
writing the C.

## Honest read

Already settled by [[decomp_ghidra_workflow]]: Ghidra output is a
first-pass comprehension aid only; raw ASM is the source of truth, and
every candidate must be sanity-checked against ASM for flag-dependence,
r4 leaks, multi-return, r10, SVC. Ghidra routinely mis-models exactly
those. It must never gate or authorise a conversion.

## Verdict

**KEEP as optional, non-authoritative display.** Rides along as a column
in the batch metadata artifact (Feature 12) if cheap; otherwise on-demand.
Never a source of truth, never a gate.

---
_Last updated: 2026-06-04 13:44:02 -0400_
