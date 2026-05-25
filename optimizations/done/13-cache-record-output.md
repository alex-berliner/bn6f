# Cache record-pass output

**Status:** implemented
**Impact:** ★★★ (huge on the dev inner loop — ~13× wall-time drop)
**Effort:** medium (cache key + orchestrator)

## Problem

The record pass (run bk2 → capture function entry snapshots +
expected exit deltas) depends only on three things:

- the original ROM,
- the bk2 input log + savestate, and
- which target addresses are being recorded.

The *decomp* ROM doesn't enter that computation. Diff-and-fail
happens later, in the replay pass against whatever decomp build you
want to check.

Steady-state decomp work changes only the decomp ROM (orig is the
fixed reference; bk2 fixtures are stable; manifest changes only when
adding/removing a target). So 99% of `make verify` invocations were
re-running the entire multi-thousand-frame bk2 to produce output
bit-identical to last run.

## Approach

On-disk cache, per-function granularity, keyed on the triple:

```
.verify-cache/<orig_rom_sha[:12]>/<bk2_input_sha[:12]>/<fn_name>/
  0000.entry.bin
  0000.exit.delta.bin
  .recorded          # marker — "considered" even if no pairs were captured
```

The record path writes pairs **directly** into the cache (no staging
into a session dir + post-promote copy). The replay path walks the
cache root for each bk2 and rayon-fans across all pairs. Cache IS
the session.

`.recorded` marker handles the "target was considered but didn't
fire" case — without it, those slots get re-recorded every run and
the cache never fully warms.

## Implementation notes

- `bn6f-track verify-all`: new subcommand owning the whole flow.
  Discovers bk2s under `tests/fixtures/demos/bk2/`, hashes inputs,
  splits targets into cached/uncached per bk2, runs record only for
  uncached (pruned RECORD_TARGETS so phase 2 doesn't waste work on
  cached fns), runs the unified replay across all populated caches
  in one rayon par_iter.
- Per-function granularity: adding one target to the decomp manifest
  invalidates only that target's slot. The other ~hundreds stay hot.
  Removing a target keeps its slot — it just won't be replayed.
- Hardlink everywhere: when record() writes to the cache, no
  promote/copy step. When replay reads, it's the same files.
- Cache invalidation = `rm -rf .verify-cache` (or any sub-tree).

## Results

`make verify` (8 bk2s, 9677 unique (entry, exit) pairs after dedup):

| Scenario | Wall | Δ vs original baseline | Δ vs pre-cache |
|---|---|---|---|
| Original baseline | 1:51.60 | — | — |
| Pre-cache (Opts 04/05/10A) | 1:06.28 | -41% | — |
| **Verify-all warm cache** | **0:08.00** | **-93%** (~13×) | **-88%** (~8×) |
| Verify-all cold (full miss) | 1:08.31 | -39% | +3% (noise) |
| Verify-all partial (2 fns invalidated) | 1:04.06 | -43% | -3% |

The warm-cache case is the typical dev loop ("I edited `src/foo.c`,
re-run verify"). 8s vs 66s changes the feel of `make verify` from
"go check something else" to "wait for it".

Cold cache is rare (first-ever run, manifest add of common functions,
manual cache wipe) and within noise of the pre-cache baseline.

## Cross-references

- Built on top of [03](done/03-parallelize-record-isolated-runs.md),
  [06](done/06-reuse-core-across-isolated-runs.md),
  [11](done/11-pipeline-phase1-phase2.md) (per-bk2 record machinery
  reused as-is — cache is layered on top).
- Cooperates with [04](done/04-direct-cpu-register-read.md) +
  the bitset (done/14): cold-cache cost is dominated by the
  per-instruction callback, which both of those optimised.
