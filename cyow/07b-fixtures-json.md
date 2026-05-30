# 07b — fixtures.json catalog

## What it is
`tests/fixtures/demos/bk2/fixtures.json` lists each fixture with a name +
prose description + `starts_from_savestate`, plus the ROM/BIOS sha1.
Deliberately does NOT duplicate frame count etc. (those live in each
bk2's Header so they can't drift).

## Pro
- Human-readable index; the "don't duplicate what's in the bk2" instinct
  is good anti-drift design.

## Con / open
- The `bios_sha1` here can itself drift from what the bk2 actually used
  (it's a hand-maintained copy). And it lists a BIOS hash while the
  movies are SkipBios (see 07c) — already mildly self-contradictory.

## Rating
**CHANGE — make it a generated build artifact, not a persisted file.**
(2026-05-30) The catalog (descriptions, frame counts, ROM/BIOS sha1,
coverage) should be **generated from the bk2s** into `build/` and be a
**dependency of validation runs**, not a hand-maintained committed JSON
(which can drift — e.g. its bios_sha1 vs the movies' actual SkipBios).
- [ ] Generate fixture metadata from the bk2 files at build time into
      `build/` (non-persistent); make runs depend on it.
- [ ] Merge with 06c's per-bk2 call-count metadata — same generated
      artifact.
- [ ] Drop the committed `fixtures.json` once generation exists (prose
      descriptions may need a small committed seed — decide).

---
_Last updated: 2026-05-30 12:41:21 -0400_
