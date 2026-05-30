# 07a — bk2 movie format as fixture

## What it is
Fixtures are BizHawk `.bk2` movies — a zip with `Input Log.txt`
(per-frame buttons), optional `Core.bin.zst` (zstd mGBA savestate),
`Header.txt`, `SyncSettings.json`, `Framebuffer.bmp`. The validator reads
the .bk2 directly (no pre-extracted `.input`/`.ss` derivatives).

## Pro
- Single self-contained source of truth per fixture; no derivative files
  to drift. Standard, reproducible-in-BizHawk format.

## Con / open
- Couples us to BizHawk's format + its mGBA core version semantics.

## Rating
**GOOD — keep, with a hard BIOS gate.** (2026-05-30) BizHawk/mGBA
semantics are acceptable. But the harness MUST reject any replay not
recorded against the **real BIOS**; HLE BIOS is never allowed. (Same rule
as 06e / 07c.)
- [ ] Harness reads each bk2's BIOS provenance and refuses to run HLE/
      SkipBios replays — fail with that explicit reason, don't silently
      run them.

---
_Last updated: 2026-05-30 12:41:16 -0400_
