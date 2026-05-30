# 07 — bk2 fixtures + vendored libmgba (overview)

The two inputs the validator runs on, split into independently-rated
subfeatures:

- [07a — bk2 movie format as fixture](07a-bk2-format.md) — **GOOD, with hard real-BIOS gate**
- [07b — fixtures.json catalog](07b-fixtures-json.md) — **CHANGE → generated build artifact, run dependency**
- [07c — SkipBios recording](07c-skipbios.md) — **BAD → re-record real BIOS; enforce gate**
- [07d — savestate-start fixtures](07d-savestate-start.md) — **KEEP → real BIOS ≠ coldboot required**
- [07e — vendored libmgba .so in git](07e-vendored-so.md) — **OK → build artifact if cheap**
- [07f — bindgen + MGBA_PREFIX override](07f-bindgen-prefix.md) — **GOOD (explained)**
- [07g — corpus breadth / coverage](07g-corpus-breadth.md) — **OK → user adds bk2s; guide via 06c**

---
_Last updated: 2026-05-30 12:41:54 -0400_
