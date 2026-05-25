# Binary-search bk2 divergence detector

**Status:** proposed
**Impact:** ★★★ (high — different *kind* of test, fast regression signal)
**Effort:** medium

## Problem

Today's verify pipeline catches regressions at **per-function-call**
granularity: every call site in every captured fixture is restored,
re-executed against the decomp ROM, and diffed. That's thorough but
slow (and the cost scales with the number of fixtures, not the number
of regressions).

For the dev inner loop, the question is often just **"did anything
regress?"** — not "which 4154 pairs all pass". A failing pair gives
the fn name, but only after the full record+replay pass.

## Approach

Run **orig and decomp ROMs in lockstep** through the bk2 input log.
Every N frames (e.g. 128), hash the live state (EWRAM + IWRAM +
registers + savestate). If the hashes match, advance. If they
diverge:

1. Roll both cores back to the last matching checkpoint (savestate
   restore).
2. Binary-search the divergence point inside the [last_match,
   current_frame] window — bisect at the midpoint, run, hash, narrow.
3. Once down to a single frame: run frame-by-frame within it,
   checking which captured function call sites fired during that
   frame and which one's exit state diverged.

Output: "first regression at frame F in function `foo()`" — typically
sufficient to point at the broken decomp.

## Implementation notes

- Lockstep emulation: two `Core` instances, one per ROM, advance one
  frame at a time, feeding identical inputs. The harness already
  knows how to do this (record vs replay both use single-core
  emulation; just twin it).
- State hash: reuse `snapshot_dedup_hash()` from main.rs which already
  hashes a Snapshot. Cheap enough at frame granularity.
- Checkpoint cadence is a tunable. 128 frames means at most 7 bisect
  steps to localize to one frame (log2 128). Larger = fewer hashes,
  slower bisect on miss. Smaller = more hashes during the clean run,
  faster bisect.
- Pairs vs frames: once localized to a frame, identifying the
  diverging function requires running with the debugger callback
  attached and capturing per-call exits. The existing record/replay
  machinery handles that; this mode just narrows *where* to look.
- Complementary to the per-call verify, not a replacement: the per-
  call mode gives exhaustive coverage; the bisect mode gives fast
  triage. Both off the same fixtures.

## When it's the right tool

- "Quick check before pushing" — `make verify-quick` style.
- Hunting a known regression: skip running 9677 pairs, just find
  the first diverging frame.
- CI: optional fast-path before the exhaustive pass.

When *not*:
- Verifying a fresh decomp — exhaustive per-call is the right tool.
- Confirming function-level cleanliness — bisect only flags the
  first divergence; downstream functions may also be broken.

## Cross-references

- Complementary to [01](done/01-hash-dedup-entries.md): state-hash
  machinery is partly shared.
- The novel-savestate-fleet idea (discussion thread, no doc yet)
  pairs naturally — each "novel" frame is also a natural lockstep
  checkpoint.

## Results

_To fill in post-implementation._ Expected: best-case detection of
"is anything wrong?" in seconds (one full lockstep pass at frameskip
+ no callbacks = essentially native emulation speed × 2 cores). Bisect
adds at most log2(N) full-bk2 passes on a miss.
