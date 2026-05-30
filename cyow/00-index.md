# Choose-Your-Own-Adventure: Decomp Toolkit Review

A feature-by-feature walkthrough of the current decomp toolkit. Each numbered
file covers one feature: what it is, how it works today, and the verdict
(good / bad + why) from the conversation.

No changes to the toolkit itself until the review is complete.
Conclusions and the running action list live in [todo.md](todo.md).

## Features (with verdicts)

1. [Candidate selection — what to decomp next](01-candidate-picker.md) — **BAD → deleted both, rebuild one**
2. [Trampoline gating (`.ifndef DECOMP_<sym>`)](02-trampoline-gating.md) — **KEEP + new relocation strategy**
3. [Wrapper macros (VTABLE / FLAG / naked)](03-wrapper-macros.md) — **NO RESOLUTION — agbcc-epilogue demonstrator required first**
4. [Manifest (tracking which symbols)](04-manifest.md) — **RESTRUCTURE → JSON manifest with per-record enabled flag**
5. [ASM `.ifndef` gating (mechanical replacement)](05-asm-ifndef-gating.md) — **KEEP `.ifndef` + single .o; stub ALL gates once via script**

## Candidate feature backlog (not yet discussed)

- Manifest + per-symbol `--defsym` build flavors (`make all` vs `make decompile`)
- `bn6f-validate` — per-frame pixel-hash runtime validator
- bk2 fixtures + vendored libmgba 0.11
- Harness divergence canary (`ByteFillCanary` + `canary.sh`)
- `tools/wrap_decomp.py` automation
- `tools/function_card.py` per-symbol summary
- agbcc toolchain / ABI constraint
- Ghidra pre-pass + token-reduction strategies
- `make validate` static ELF check (`tools/validate_asm.py`)

---
_Last updated: 2026-05-30 11:36:44 -0400_
