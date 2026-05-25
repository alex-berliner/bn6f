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
| 04 | [Direct CPU register reads in custom_cb](04-direct-cpu-register-read.md) | proposed |
| 05 | [Compress stored snapshots](05-compress-snapshots.md) | proposed |
| 07 | [Parallelize bk2 replays](07-parallelize-bk2-replays.md) | proposed |
| 08 | [Skip RECORD for uncalled functions](08-skip-uncalled-functions.md) | proposed |
| 09 | [Skip IRQ-isolation for pure functions](09-skip-irq-isolation-for-pure-fns.md) | proposed |
| 10 | [Disable rendering entirely](10-disable-rendering-entirely.md) | proposed (supersedes 02) |

## Done

| # | Title | Result |
|---|---|---|
| 01 | [Hash-dedup entry snapshots](done/01-hash-dedup-entries.md) | implemented |
| 02 | [Frameskip headless rendering](done/02-frameskip-headless.md) | implemented (inconclusive) |
| 03 | [Parallelize record-side isolated runs](done/03-parallelize-record-isolated-runs.md) | -39% on `make verify` |
| 06 | [Reuse libmgba core across isolated runs](done/06-reuse-core-across-isolated-runs.md) | -20% on top of 03 (-51% from original) |
| 11 | [Pipeline phase 1 (capture) and phase 2 (expected-exit)](done/11-pipeline-phase1-phase2.md) | -11% on top of 03+06 (-57% from original) |
