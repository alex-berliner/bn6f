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

## BIOS hash — VERIFIED MATCH (2026-05-30)
`sha1sum /home/alex/gbabiosworld.bin` =
**`300c20df6731a33952ded8c436f7f186d25d3492`**, which **equals** the
`300C20DF...` named in the fixtures' `Header.txt` / `fixtures.json`. So
the fixtures reference the **correct canonical BIOS** ([[gba_bios_path]]).
The only problem is SkipBios — boot is bypassed despite the right BIOS
being present. (Earlier draft claimed a mismatch with a `2ee2d42c…` hash;
that hash was fabricated — retracted.)

## Verdict — BAD → re-record with SkipBios off
- [ ] Re-record all 3 fixtures with **SkipBios off** against
      `gbabiosworld.bin` (`300c20df…`). The BIOS identity is already
      correct; only the skip-boot flag is wrong.
- [ ] The harness real-BIOS gate (06e/07a) checks against
      **`300c20df…`**.
- [ ] Coupled to 07d: savestate-start fixtures' savestates must be
      regenerated from a real-BIOS (non-SkipBios) run, not flag-flipped.

## Rating
**BAD → re-record (same rule as 7a/06e).** (2026-05-30) HLE/SkipBios is
never acceptable. User will regenerate the bk2s with BIOS enabled — no
need to preserve the current tests (see 07d). Harness must additionally
*enforce* the gate so this can't regress.
- [ ] User regenerates all fixtures with real BIOS (SkipBios off).
- [ ] Harness rejects any non-real-BIOS replay with an explicit failure.

---
_Last updated: 2026-05-30 12:51:30 -0400_
