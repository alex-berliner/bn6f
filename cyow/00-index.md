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
6. [bn6f-validate (overview)](06-validate-overview.md) — split into subfeatures:
   - [06a correctness oracle](06a-correctness-oracle.md) — **CHANGE → memory/full-state diff; kill VBlank drift via relocation**
   - [06b build matrix + result log](06b-build-matrix-and-log.md) — **EXPAND → per-patch AND combined; patch_result.log**
   - [06c bk2 coverage gating](06c-bk2-coverage-gating.md) — **BUILD → per-bk2 call counts; skip uncalled cases**
   - [06d audio](06d-audio.md) — **subsumed by full-state parity (06a)**
   - [06e BIOS](06e-bios.md) — **NEVER HLE; require real BIOS or fail all**
   - [06f parallel fan-out](06f-parallel-fanout.md) — **GOOD**
   - [06h videos](06h-videos.md) — **on-demand flag, informal, small filesize**
7. [bk2 fixtures + vendored libmgba (overview)](07-fixtures-libmgba-overview.md) — split into subfeatures:
   - [07a bk2 format](07a-bk2-format.md) — **GOOD + hard real-BIOS gate**
   - [07b fixtures.json](07b-fixtures-json.md) — **CHANGE → generated build artifact**
   - [07c SkipBios](07c-skipbios.md) — **BAD → re-record real BIOS**
   - [07d savestate-start](07d-savestate-start.md) — **KEEP (real BIOS ≠ coldboot)**
   - [07e vendored .so](07e-vendored-so.md) — **OK → build artifact if cheap**
   - [07f bindgen/MGBA_PREFIX](07f-bindgen-prefix.md) — **GOOD**
   - [07g corpus breadth](07g-corpus-breadth.md) — **OK → guide via 06c**

## Candidate feature backlog (not yet discussed)

- Harness divergence canary (`ByteFillCanary` + `canary.sh`)
- `tools/wrap_decomp.py` automation
- `tools/function_card.py` per-symbol summary
- agbcc toolchain / ABI constraint
- Ghidra pre-pass + token-reduction strategies
- `make validate` static ELF check (`tools/validate_asm.py`)

---
_Last updated: 2026-05-30 12:42:08 -0400_
