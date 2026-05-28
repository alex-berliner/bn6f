# 18 — mTimingCurrentTime returns wrapping int32

**Class:** mGBA / emulator
**Severity:** absurd cycle-delta computations across long runs
**Status:** documented; use wrapping_sub or switch to mTimingGlobalTime

## Symptom

You write code in `bn6f-track` that computes cycle deltas using
`mTimingCurrentTime`:

```rust
let start = mTimingCurrentTime(timing);
do_work();
let end = mTimingCurrentTime(timing);
let elapsed = end - start;
```

For short windows this works fine. For longer windows (many seconds
of game time) `elapsed` becomes negative or absurdly large, even
though work clearly took positive time.

## Why

`mTimingCurrentTime` returns `int32_t` — a 32-bit signed integer. mGBA
schedules timing events using this counter and **resets it
periodically** to avoid overflow. The reset is implementation-detail;
from the API's perspective the counter just wraps unpredictably.

For a function that runs across one of those resets, naive subtraction
gives wrong values.

## Fix

Two options:

### 1. Use signed wrapping_sub for short-window deltas

```rust
let elapsed = end.wrapping_sub(start);   // handles wrap correctly
```

For windows shorter than i32::MAX / 2 ≈ 1.07 billion cycles (about
60 seconds of game time at GBA's 16.78 MHz), this gives the right
answer modulo wrap.

The slack profiler (`bn6f-track slack`) uses this — it only cares
about the visible-period budget within a single frame
(< 300K cycles), well within the safe range.

### 2. Use mTimingGlobalTime for long windows

`mTimingGlobalTime` returns `uint64_t` — the absolute cycle counter
that never wraps within the lifetime of any reasonable run.

```rust
let start = mTimingGlobalTime(timing);
...
let end = mTimingGlobalTime(timing);
let elapsed = end - start;   // never wraps
```

Use this for any cross-frame or cross-second computation.

## When this bit us

Originally, the slack profiler computed `mainline_cycles =
end.wrapping_sub(frame_start_cy)` per frame. That works fine within a
single frame, but across frames the running totals could go negative
in intermediate calculations. Switched to instruction-count rather
than cycle-count for the per-frame metric.

## Related

- `tools/bn6f-track/src/main.rs::slack`
- `tools/libmgba/include/mgba/core/timing.h`
