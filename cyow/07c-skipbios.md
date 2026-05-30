# 07c — SkipBios recording (the big one)

## Finding
All 3 fixtures have `SkipBios: true` (verified in
`intro.bk2/SyncSettings.json`). The bk2 `Header.txt` names a real BIOS
(`300C20DF...`, retail dump sha1) and `fixtures.json` repeats it — so
BizHawk *had* a BIOS loaded, but boot was bypassed anyway.

## Why it matters
Collides head-on with **06e** ("never HLE / always real BIOS, boot
included"). Whether via HLE or SkipBios, the real boot path is not what
these fixtures captured.

## BIOS hash discrepancy (verified 2026-05-30)
The canonical BIOS is the user's `/home/alex/gbabiosworld.bin`, sha1
**`2ee2d42cf1c0f06efe1f4eac35a44a0c52d3c6f5`** ([[gba_bios_path]], source
of truth). The fixtures name `300C20DF...` (the well-known retail GBA
BIOS hash) — these **do not match**. So the current fixtures reference a
*different* BIOS than the canonical dump, on top of being SkipBios.
Per the user, `gbabiosworld.bin` wins; `300C20DF...` is the wrong value.

## Verdict — BAD → re-record against the canonical BIOS
- [ ] Re-record all 3 fixtures with **SkipBios off** against
      `gbabiosworld.bin` (`2ee2d42c…`).
- [ ] The harness real-BIOS gate (06e/07a) must check against
      **`2ee2d42c…`**, NOT the `300C20DF…` currently in `fixtures.json`.
- [ ] Coupled to 07d: savestate-start fixtures' savestates must be
      regenerated from a real-(`2ee2d42c…`)-BIOS run, not just flag-flipped.

## Rating
**BAD → re-record (same rule as 7a/06e).** (2026-05-30) HLE/SkipBios is
never acceptable. User will regenerate the bk2s with BIOS enabled — no
need to preserve the current tests (see 07d). Harness must additionally
*enforce* the gate so this can't regress.
- [ ] User regenerates all fixtures with real BIOS (SkipBios off).
- [ ] Harness rejects any non-real-BIOS replay with an explicit failure.

---
_Last updated: 2026-05-30 12:50:53 -0400_
