# Function-coverage strategies — comparison + proposal

**Status:** D implemented; B still proposed
**Impact:** ★★★ for (D), conditional for (B)
**Effort:** varies

This doc is a design comparison of the approaches we have or could
have for "is the decomp ROM bit-equivalent to the original?". It
exists to (a) make the tradeoffs explicit before we build more
infrastructure, and (b) propose **incremental verification (D)** as
the next high-ROI addition.

## Approaches

### A — Per-call delta verification (current)

For each captured `(entry_snapshot, expected_exit_delta)` pair, restore
the entry into the decomp ROM, run until LR, diff actual exit against
the cached delta. This is what `make verify` does today.

- Cold cache: ~62s (run bk2 once to populate, then replay).
- Warm cache: ~8s (replay only — no bk2 emulation).
- Coverage: exhaustive over (function × call-context) pairs that the
  bk2 playthrough actually visits.

### B — Divergence bisect

Run orig + decomp ROMs in lockstep through the bk2 input log. Hash
state at every frame. On first hash mismatch, bisect backward to
find the exact diverging frame; then run that frame with the
debugger callback attached to identify which function call caused
the divergence.

- Cost: roughly 2× the orig ROM's emulation time (two cores).
  Estimated 10-20s for the current bk2 fleet.
- Coverage: **first diverging frame only**. Downstream regressions
  are masked until the first one is fixed.
- Unique strength: catches **inter-function interactions** that
  per-call A doesn't — e.g. counter drift, RNG desync,
  frame-anchored state machines crossing phase boundaries.

### C — Per-function savestate corpus ("just use savestates")

For each function, maintain a corpus of savestates that exercise it.
Verification = restore savestate, run until function returns, diff
exit. No bk2 emulation needed at verify time.

**This is what A already is.** Mechanically identical:

- `<cache>/<orig>/<bk2>/<fn>/0000.entry.bin` *is* a savestate.
- `<cache>/<orig>/<bk2>/<fn>/0000.exit.delta.bin` *is* the expected
  post-call delta.
- Warm-cache verify does not re-run the bk2; restore + run + diff
  is the flow.

The only thing C-as-stated changes is *what selects which functions
to verify*. If hand-curated savestates, you lose the bk2's
organically-curated coverage and pick up the unit-test-authoring
burden (~489 functions). If auto-extracted from bk2s, you're back
to A. **Net: no benefit, real cost.**

### D — Incremental verification (implemented)

Layer on top of A: only re-run pairs whose function code has
actually changed (transitively).

**Cache key per pair:** `(pair_path, decomp_fn_bytes_sha,
callees_closure_sha)`. On verify:

1. For each cached pair, hash the decomp ROM's bytes covering this
   fn's address range, plus the bytes of every fn it transitively
   calls.
2. If both hashes match a prior pass → mark the pair "still passing",
   skip.
3. Otherwise add to the work queue and run it. Record the result.

Typical inner-loop change touches 1-3 fns × handful of callers.
**Pair work queue shrinks from 9677 → ~5-50 pairs.** Measured
results below.

### Results

`make verify` on the two-bk2 fleet, with D landed:

| Scenario | Wall | Pairs run |
|---|---|---|
| Cold cache (first ever run) | 1:01.40 | 9677 |
| Warm + nothing changed | **0:04.67** | **0** (all 347 fns trusted) |
| One fn's pair_pass entry removed | 0:04.76 | 51 (that fn's pairs only) |
| One fn's cache wiped, decomp unchanged | 0:55.78 | 0 (re-records but skips replay) |

The "nothing changed" 4.67s is the floor — ROM build (~2s) + Rust
startup + bk2/orig hashes + symbol/cache parse + the eager
hash-everything-once setup. Phase B replay itself is now ~0s when
incremental holds.

The "one fn cache wiped" case correctly re-records but then skips
the replay (the freshly-captured pairs are bit-identical to the
prior green run's, against an unchanged decomp ROM, so the prior
pass result still holds).

## Comparison matrix

| | What it tests | Cold-cache cost | Steady-state cost | Coverage gaps |
|---|---|---|---|---|
| **A** (current) | Each captured pair, independently | 62s | 8s | bk2-unvisited paths; inter-fn interactions |
| **B** | First diverging frame in lockstep | ~10-20s | ~10-20s | downstream of first divergence |
| **C** | (same as A) | (same) | (same) | (same) + curation cost |
| **D** (= A + incremental) | Pairs in changed code radius | (same as A) | **4.7s when nothing changed; ~5s + the changed-radius pairs otherwise** | same as A |

## How D was implemented

- **Callgraph capture during record.** New `CALLGRAPH` thread_local
  in `main.rs`. At every BL detection in the per-instruction
  callback we record `(caller_fn → callee_fn)`. Caller = top of
  `PENDING` stack (so calls from top-level get dropped — they
  don't contribute to any captured fn's radius).
- **Persist to cache.** After each `record()` we translate the
  addr-keyed map to fn-names (via the symbol table) and write
  `<cache>/<orig>/<bk2>/callgraph.txt` — one `caller<TAB>csv` line
  per caller. Stable / diffable / dep-free format.
- **Radius hash per fn.** In phase B we read the decomp ROM bytes
  once, build a `fn_name → (start, end_exclusive)` map from the
  symbol table (end = next fn's start, same convention as `FN_END`),
  and for each fn compute `sha1(concat(decomp_bytes[range] for fn
  in sort(closure)))` where the closure is BFS over the callgraph.
- **Per-pair-pass cache.** `<cache>/<orig>/<bk2>/pair_pass.txt`
  stores `fn_name<TAB>radius_sha` for every fn whose pairs passed
  on the last green run. On replay setup, a fn whose current
  radius matches its prior entry is skipped entirely. After
  replay, the file is updated: fresh radii for fully-passing fns;
  failing fns get their entry removed (don't poison the cache).
- **Missing-callgraph fallback.** If `callgraph.txt` doesn't exist
  (cache predates this code) we disable incremental for that bk2
  rather than risk over-skipping.

## Recommendation

Three-tier setup:

1. **Keep A as the backbone.** Don't switch to C — same machinery,
   no benefit, loses bk2-driven coverage curation.

2. **Build D next.** Bigger ROI than B for the dev inner loop:
   warm 8s → ~1s changes daily feel. Cache infrastructure is
   already in place (`.verify-cache/`); add per-pair result cache
   keyed on callgraph-closure hash. Half-day to a day of work.

3. **Build B separately for triage.** Different problem, different
   tool. Best uses:
   - Post-refactor sanity check.
   - Hunting integration bugs A's per-call tests miss.
   - CI fast-fail before the exhaustive A pass.

   Implement as `bn6f-track bisect`. No fixtures needed — operates
   directly on orig + decomp + bk2.

### Anti-recommendation: avoid switching frameworks A → C

The framing shift "savestate corpus per function" is the same
machinery we have. The actual new idea worth pursuing is **selection
of which savestates to re-run** (= D). Don't restructure the
fixture format; refine which fixtures get exercised.

### Open question — input fuzzing

A fifth approach worth flagging: generate plausible random states,
replay through both ROMs, compare. Catches bugs in code paths the
bk2 never visits. Risk: impossible states trigger different but
correct behaviour between orig and decomp (false positives).
Probably not worth pursuing until A+D leaves coverage gaps we can
*name*.

## Cross-references

- [12](12-binary-search-bk2-divergence.md) — approach B in detail.
- [13](done/13-cache-record-output.md) — approach A's cache machinery;
  D would extend it with a per-pair result cache.
- [14](done/14-entry-bitset.md) — orthogonal callback hot-path opt.
