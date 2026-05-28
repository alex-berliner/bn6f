# 13 — last-frame PPM is necessary but not sufficient

**Class:** verification model
**Severity:** missed regressions in code paths that converge by end
**Status:** documented; plan for second-stage lockstep sweep

## Symptom

A C port passes `per_patch_last_frame.sh` for all 3 bk2s. Cumulative
`per_patch_combined_test.sh` also passes. But hidden inside the run
is a real bug — a transient mid-bk2 divergence that *happens to
resolve* by the end. The bug doesn't affect the final framebuffer
but might affect:

- save data state (if the bk2 fixture doesn't trigger a save)
- a counter that goes wrong, then gets reset
- mid-cutscene visuals that the player would see but aren't captured
  by the final-frame comparison

## Why

The last-frame check only samples one pixel-correctness state at the
end of the bk2 input log. Any divergence that doesn't persist to
that final moment is invisible to it.

Trampoline cycle drift makes this common: drift causes 1-byte EWRAM
diffs mid-bk2, but downstream code usually overwrites the diverged
byte with a fresh value, converging back to orig. The "end-state
matches" outcome holds even though there was real drift.

For drift, that's fine — we want to accept drift as not-a-bug. But
for **real C-port bugs that also converge by end**, last-frame
silently passes them.

## How to detect

Last-frame alone can't catch these. You need either:

- A multi-checkpoint PPM check — sample at frame N/4, N/2, 3N/4, N
  and require all to match. Catches more transient bugs, still misses
  some.
- A full `lockstep` pass with the drift classifier. `class=bug`
  divergences that converge by end are exactly the class this catches.
- Per-call snapshot verification (`make verify`) — catches semantic
  bugs in the function body regardless of converge-by-end behaviour.

## Fix (verification stack)

Layered approach:

1. **last-frame PPM** (cheap, fast) — primary filter. PASS means very
   likely good. FAIL means investigate immediately.
2. **per_patch_combined_test** (still cheap) — catches interactions.
3. **`make verify` per-call snapshot** (per-fn, medium) — catches
   semantic bugs that would otherwise be invisible to frame-level
   checks.
4. **`bn6f-track lockstep` with drift classifier** (per-fn × 3 bk2s,
   expensive but parallelizable to ~7 hours total) — final
   transient-bug catcher.

The autonomous loop is running layer 1 + layer 2 currently. Layers 3
+ 4 are planned second-pass checks on the validated set.

## When this bit us

Not directly yet — the autonomous loop is still in the layer 1 sweep.
Listed as a known limitation so we don't claim "validated" without
qualifying.

## Related

- `docs/verification.md`
- `docs/pitfalls/02-trampoline-cycle-drift.md`
- `docs/pitfalls/09-lockstep-false-positives.md`
- `tools/per_patch_last_frame.sh`
