# 14 — tutorial bk2 doesn't exercise all functions

**Class:** verification model / fixture coverage
**Severity:** untested code paths can have bugs that pass our harness
**Status:** acknowledged limitation; expanded bk2 set planned

## Symptom

A C port passes every available check (last-frame PPM, combined-test,
even lockstep with drift classifier). But the function isn't actually
called during any of our bk2 fixtures (coldboot, intro,
intro_to_end_tutorial) — so the verdict is meaningless: we never
exercised the converted code.

## Why

The bk2 fixtures cover only the early-game player path:

- **coldboot**: 417 frames. BIOS handoff + Capcom/IntSys logos.
- **intro**: 6239 frames. Title screen + cutscene.
- **intro_to_end_tutorial**: 16441 frames. Tutorial battle.

Many decomp-target functions are only invoked in code paths that
those bk2s don't reach:

- Save/load functions: no save triggered in fixtures
- Shop functions: no shop visited
- Multiplayer / Serial functions: no link cable activity
- Most chip-folder edit functions
- Most NaviCust functions
- Many cutscene functions for events we don't reach
- Most chatbox / message-box variants for dialogs we don't see

For these, the per-patch decomp ROM is structurally different from
orig (it has a trampoline + extension-space body) but functionally
identical *at the bk2-observable layer* because the patched function
is never called. Our checks pass trivially.

## How to detect

Two ways:

**Statically**: grep for `bl <fn>` across `asm/*.s`. If the function
is called from non-fixture-reachable code paths, the bk2 won't
exercise it.

**Dynamically**: instrument the per-patch ROM to log when the
patched function is entered. If the log is empty after a bk2 run,
the function wasn't called.

A simpler proxy: when batch 16-30 was rendering, 14 of 15 different
patches produced **identical decomp mp4 outputs** for the tutorial
bk2. That's because none of those 14 patched functions were called
during the tutorial — so the runtime behavior was the same regardless
of which one was enabled.

## Fix (long term)

Expand the bk2 fixture set to cover:

- A save game (saving exercises a known suite of functions)
- A shop visit (chip / subchip shops, item purchases)
- A NaviCust edit session (block placement, customization)
- A folder edit session (chip swap, navi change)
- A multiplayer / Network Battle setup (link cable code)
- A virus busting battle (different code path than tutorial battle)
- A boss / cutscene-heavy chapter

Each bk2 adds coverage but also runtime cost — a tutorial-length
bk2 takes ~6 min through the per-patch sweep. Adding 5-6 more bk2s
would multiply that.

## Fix (short term)

Acknowledge the limitation. When a patch's category implies it's
only called in unexplored paths (e.g. save/shop/multiplayer), flag
the patch as "passes but not exercised" rather than "verified."

Plan: when a function like `subsystem_launchMail_c` passes — knowing
the fixtures don't trigger mail — we should explicitly call out the
weak verification status before considering it "done."

## Related

- `docs/pitfalls/13-last-frame-not-sufficient.md`
- `tests/fixtures/demos/bk2/` (current fixture set)
- `tests/fixtures/demos/README.md` (fixture conventions)
