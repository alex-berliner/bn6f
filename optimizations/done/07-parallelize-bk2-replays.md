# Parallelize bk2 replays

**Status:** implemented
**Impact:** ★★★ (high — for `make verify`)
**Effort:** low (xargs sketch) → medium (build-race teardown forced a
`verify-state` split + per-flavour ROM artefacts)

## Problem

`make verify` looped every `tests/fixtures/demos/bk2/*.bk2` and ran
`verify-state` for each **sequentially** via a shell `for` loop.
Each `verify-state` invocation is its own bn6f-track process working
on a disjoint session-dir — fully independent.

Even though each individual `verify-state` already parallelises its
*internal* replay phase via rayon, the outer loop bottlenecked the
whole target to (sum of single-bk2 times).

## Approach

Used `make -j` over per-bk2 `.PHONY` targets (`verify-bk2-<stem>`)
rather than `xargs -P`. Reasons:

- Native make error propagation (xargs returns 123 on partial fail).
- `--output-sync=line` gives clean per-worker line interleaving free.
- User can override the fan-out with `make -jN verify` directly.

`STATE_FRAMES` derivation from the `.input` file size moved into
`verify-state`'s auto-resolver so callers don't need to compute it.

## Build-race teardown

The naive version hit two distinct races at `-j2`:

1. **Per-flavour ROM file collision.** Both `make all` and `make
   decompile` write the same `$(ROM)` path; two workers in different
   phases overwrote each other's `bn6f.gba`.
2. **`clean-conditional-objs` race on `rom.o`.** `bn6f_orig.elf`'s
   prereq list (`clean-conditional-objs $(OFILES)`) is unordered
   under `-j`, so the clean step occasionally fired *after*
   `$(OFILES)` was built, deleting `rom.o` while `ld` was still
   reading it. This was a pre-existing fragility in the build that
   only surfaces under parallel make.

Both went away once the outer `verify` recipe:

- Pre-builds both ROM flavours **serially** into stable filenames
  (`build/bn6f_orig.gba`, `build/bn6f_decomp.gba`).
- Hands those paths to the workers via `ROM_ORIG_PREBUILT` /
  `ROM_DECOMP_PREBUILT`.
- Workers list **no build prereqs** and dispatch to a new
  `verify-state-impl` target that skips the inner `make all` /
  `make decompile` when the prebuilt paths are set.

`verify-state` itself remains as a thin ad-hoc wrapper: depends on
`track-build $(FN_SYMS)` for build-prereq freshness, then delegates
to `verify-state-impl`. Direct invocation (`make verify-state
STATE_NAME=...`) still works the same way.

## Implementation notes

- `VERIFY_PARALLEL` defaults to `nproc/4` so each parallel worker
  still gets ~4 cores for its inner rayon work. On a 16-core box
  with 2 bk2s, that's `-j4` outer × ~4 inner = 16 — perfect fit.
- Memory: each record phase keeps captured entry snapshots in
  memory (~288 KB × thousands). 2 bk2s in parallel is fine; reassess
  if many more bk2s land.
- Output interleaving: `--output-sync=line` keeps lines whole.

## Results

Measured on the 2-bk2 fleet (intro 6239 frames, intro_to_end_tutorial
16441 frames), 16-core box:

| | real | user | sys |
|---|---|---|---|
| Serial baseline (post 03+06+11) | **2m45.6s** | 3m02.9s | 0m36.3s |
| `-j4` fan-out (this) | **1m47.4s** | 2m53.2s | 0m33.9s |

**-35% wall time.** Speedup bounded by the longest single bk2
(intro_to_end_tutorial ≈ 100s record + ~10s replay); intro now hides
entirely behind it. Adding more bk2s scales linearly until the
longest one is the floor.

Per-bk2 timings unchanged (intro: 42.9s/45.3s record fps before/after;
tutorial: 100.9s/104.9s) — confirming the win is purely from outer
concurrency, not per-bk2 work.
