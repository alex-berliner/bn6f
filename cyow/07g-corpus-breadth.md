# 07g — corpus breadth / coverage

## What it is
Only 3 fixtures total. No measurement of which functions each one
actually exercises.

## Why it matters
- Whatever code paths the 3 bk2s don't touch are entirely unvalidated.
- Overlaps **06c** (bk2 metadata + per-function call counts): the fix is
  the same instrument — build per-bk2 call-count metadata, then we can
  both (a) skip uncalled test cases and (b) measure corpus coverage and
  know where to add fixtures.

## Direction
- [ ] Drive new-fixture creation by coverage gaps surfaced by 06c, not by
      guesswork. (Don't just "add more bk2s" blindly.)
- [ ] Battle, network/comms, and deeper menus look likely-underexercised
      vs. the intro/tutorial-heavy current set — confirm via 06c data.

## Rating
**OK — user will add more bk2s.** (2026-05-30) Not a tooling defect; the
corpus grows over time. The leverage is in 06c (coverage measurement) so
new fixtures target real gaps. No action on the tooling beyond making
06c's coverage data available to guide what the user records next.
- [ ] Surface 06c coverage so the user knows which subsystems are
      underexercised when authoring new bk2s.

---
_Last updated: 2026-05-30 12:41:46 -0400_
