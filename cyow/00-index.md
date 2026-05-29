# Choose-Your-Own-Adventure: Decomp Toolkit Review

A feature-by-feature walkthrough of the current decomp toolkit. Each numbered
file covers one feature: what it is, how it works today, and the verdict
(good / bad + why) from the conversation.

No changes to the toolkit itself until the review is complete.

## Features

1. [Candidate selection — what to decomp next](01-candidate-picker.md) — _pending verdict_

(more added as we go)

## Candidate feature backlog (not yet discussed)

- ASM gating + `decomp_trampoline` macro (`.ifndef DECOMP_<sym>`)
- Wrapper macros (`DECOMP_VTABLE_WRAPPER`, `DECOMP_FLAG_WRAPPER`, naked)
- Manifest + per-symbol `--defsym` build flavors (`make all` vs `make decompile`)
- `bn6f-validate` — per-frame pixel-hash runtime validator
- bk2 fixtures + vendored libmgba 0.11
- Harness divergence canary (`ByteFillCanary` + `canary.sh`)
- `/decomp-step` loop skill + `decomp_stats.tsv`
- `tools/wrap_decomp.py` automation
- `tools/function_card.py` per-symbol summary
- agbcc toolchain / ABI constraint
- Ghidra pre-pass + token-reduction strategies
- `make validate` static ELF check (`tools/validate_asm.py`)

---
_Last updated: 2026-05-29 12:59:48 -0400_
