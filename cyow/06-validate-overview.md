# 06 — bn6f-validate (overview)

The Rust+libmgba correctness gate, split into independently-rated
features. Each subfeature has its own file + verdict:

- [06a — correctness oracle (pixel-hash → RAM/state diff)](06a-correctness-oracle.md) — **CHANGE: move to memory/full-state diffing; attack VBlank head-on via relocation**
- [06b — per-patch + combined builds, result log](06b-build-matrix-and-log.md) — **EXPAND: do both isolated AND all-patch; structured patch_result.log**
- [06c — bk2 metadata + call-coverage gating](06c-bk2-coverage-gating.md) — **BUILD IT: per-bk2 per-function call counts; skip untested-symbol cases**
- [06d — audio validation](06d-audio.md) — **subsumed by full-state parity (06a)**
- [06e — BIOS](06e-bios.md) — **NEVER HLE: require real BIOS, else fail all with that reason**
- [06f — parallel subprocess fan-out](06f-parallel-fanout.md) — **GOOD**
- [06g — (folded into 06h)](06h-videos.md)
- [06h — videos](06h-videos.md) — **on-demand flag only, informal review, optimize filesize**

---
_Last updated: 2026-05-30 12:09:55 -0400_
