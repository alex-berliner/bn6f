# 08b — Static .ifdef design

## What it is
The canary lives permanently in the tree behind `.ifdef
DECOMP_ByteFillCanary` (note: `ifdef`, opposite of the normal `ifndef`
gate), at validator index 7_000_001 so its build artifacts never collide
with real patches. Running it never mutates source (replaced an older
stash/source-swap design — commit 5868d7c9).

## Why it matters
- Clean: no stash/restore dance, no risk of leaving the tree dirty.
- Self-documenting exit codes.

## Rating
**GOOD.** (2026-05-30) Keep the static `.ifdef` / index-7000001 design.

---
_Last updated: 2026-05-30 13:02:47 -0400_
