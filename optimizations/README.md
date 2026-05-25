# bn6f-track optimizations

Tracking ideas to speed up the verification harness (`bn6f-track` +
`make verify*`). One file per idea. Format:

- **Status:** proposed | implemented | abandoned
- **Impact / Effort:** rough sizing pre-implementation
- **Results:** filled in post-implementation with before/after wall-clock
  numbers and what workload was measured

## Proposed

| # | Title | Status |
|---|---|---|
| 08 | [Skip RECORD for uncalled functions](08-skip-uncalled-functions.md) | proposed |
| 09 | [Skip IRQ-isolation for pure functions](09-skip-irq-isolation-for-pure-fns.md) | proposed |
| 12 | [Binary-search bk2 divergence detector](12-binary-search-bk2-divergence.md) | proposed |
| 15 | [Coverage strategies + incremental verify (D)](15-coverage-strategies.md) | proposed |

## Done

| # | Title | Result |
|---|---|---|
| 01 | [Hash-dedup entry snapshots](done/01-hash-dedup-entries.md) | implemented |
| 02 | [Frameskip headless rendering](done/02-frameskip-headless.md) | implemented (inconclusive); superseded by 10A |
| 03 | [Parallelize record-side isolated runs](done/03-parallelize-record-isolated-runs.md) | -39% on `make verify` |
| 04 | [Direct CPU register reads](done/04-direct-cpu-register-read.md) | **-41% on `make verify`** (on top of 10A+05) |
| 05 | [Compress stored snapshots (zstd)](done/05-compress-snapshots.md) | ~13× smaller fixtures; wall-time wash |
| 06 | [Reuse libmgba core across isolated runs](done/06-reuse-core-across-isolated-runs.md) | -20% on top of 03 (-51% from original) |
| 07 | [Parallelize bk2 replays](done/07-parallelize-bk2-replays.md) | -35% on `make verify` (on top of 03+06+11) |
| 10 | [Disable rendering — Option A](done/10-disable-rendering-entirely.md) | Option A landed: -1.5% (marginal — B/C deferred) |
| 11 | [Pipeline phase 1 (capture) and phase 2 (expected-exit)](done/11-pipeline-phase1-phase2.md) | -11% on top of 03+06 (-57% from original) |
| 13 | [Cache record-pass output + verify-all orchestrator](done/13-cache-record-output.md) | **-93% on warm cache (8s vs 112s baseline, ~13×)** |
| 14 | [ENTRIES bitset](done/14-entry-bitset.md) | -9% on cold-cache record phase |
