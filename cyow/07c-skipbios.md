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

## Verdict (expected: BAD → re-record)
- [ ] Re-record all 3 fixtures with **SkipBios off** against the real
      BIOS ([[gba_bios_path]]).
- [ ] First verify `300C20DF...` equals the sha1 of the user's
      `/home/alex/gbabiosworld.bin` before trusting it.
- [ ] Coupled to 07d: the savestate-start fixtures can't simply flip the
      flag (their savestates were made under SkipBios).

## Rating
**BAD → re-record (same rule as 7a/06e).** (2026-05-30) HLE/SkipBios is
never acceptable. User will regenerate the bk2s with BIOS enabled — no
need to preserve the current tests (see 07d). Harness must additionally
*enforce* the gate so this can't regress.
- [ ] User regenerates all fixtures with real BIOS (SkipBios off).
- [ ] Harness rejects any non-real-BIOS replay with an explicit failure.

---
_Last updated: 2026-05-30 12:41:24 -0400_
