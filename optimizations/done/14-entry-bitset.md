# ENTRIES bitset

**Status:** implemented
**Impact:** ★★ (~10% on the cold-cache record phase)
**Effort:** low

## Problem

After [04](04-direct-cpu-register-read.md) made the per-instruction
register reads cheap, the remaining hot work inside `custom_cb` was:

```rust
let is_entry = ENTRIES.with(|e| e.borrow().contains(&true_pc));
```

`ENTRIES` was a `HashSet<u32>` of ~13K function entry addresses. Each
callback fired this lookup, so the hash + RefCell::borrow + bucket
probe cost ran billions of times per `make verify`.

## Approach

Replace the HashSet with a bitset indexed by `(pc - ROM_BASE) >> 1`.
2-byte stride preserves Thumb half-word alignment. ROM is ~1.5 MB of
function-bearing code, giving a bitset of ~85 KB — fits in L2.

Per-callback work shrinks from "hash the u32, probe bucket chain" to
"compare to base, shift, load word, bit test". A few ns instead of
tens of ns.

## Implementation notes

- `EntryBitset` struct in main.rs; thread_local instance in place of
  the old HashSet. Built once at the start of `record`/`track`.
- `contains()` uses `get_unchecked` after a bounds check on the
  computed slot index — no panic branch in the hot path.
- Out-of-ROM PCs (IWRAM, EWRAM) get a fast-path `false` return.
  Functions in those regions aren't in our manifest anyway.

## Results

`make verify` (cold cache, since warm-cache runs skip the bk2
emulation entirely):

| State | Wall | Δ |
|---|---|---|
| Pre-bitset (cache + orchestrator) | 1:08.31 | — |
| **Post-bitset** | **1:01.94** | **-9%** |

Warm-cache wall time unchanged (no record runs to optimise).

## Cross-references

- Direct successor to [04](04-direct-cpu-register-read.md) —
  attacks the same hot path.
- Could potentially be combined with a libmgba fork that inlines
  the callback dispatch entirely (deferred — see optimization 03
  in proposed list).
