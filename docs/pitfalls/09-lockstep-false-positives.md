# 09 — per-frame strict lockstep false positives

**Class:** verification model
**Severity:** wastes investigation time on non-bugs
**Status:** classifier shipped, model documented

## Symptom

`bn6f-track lockstep` reports a patch as RED with persistent state
divergence. You dig in expecting a real C-port bug, find nothing
wrong with the semantics, and the patch passes last-frame PPM check
and the per-call snapshot oracle. Hours lost.

## Why

Trampoline cycle drift (pitfall 02) produces transient mid-bk2
divergence that doesn't reflect any C-code bug. The per-frame
lockstep model demands byte-parity at every frame, which is
mathematically incompatible with adding cycles to mainline (which
every trampoline does).

The same patch, judged by:

- `make verify` (per-call snapshot): PASS — semantics correct
- `bn6f-track lockstep`: RED at frame N — drift caught
- `per_patch_last_frame.sh`: PASS — end-state matches
- `bn6f-track lockstep` with drift classifier: RED class=drift

Three of those four say "fine," one says "broken." The lockstep
oracle is over-strict for the trampoline era.

## Fix

The drift classifier in `bn6f-track lockstep`. Each RED divergence is
labeled:

- `class=drift` — likely cycle overhead pushed mainline past VBlank
- `class=bug` — likely real C-port issue (multiple persistent regions
  hit, or cross-region PC delta)
- `class=mixed` — ambiguous, manual inspection

Classifier heuristic in `tools/bn6f-track/src/main.rs::lockstep()`:

```rust
let class = if persist_count == 0 {
    "drift"               // pure CPU-reg delta
} else if persist_count <= 1 && same_region {
    "drift"               // single-byte VBlank race
} else if persist_count >= 3 || !same_region {
    "bug"                 // multiple regions or cross-region jump
} else {
    "mixed"
};
```

The RESULT line carries `class=...` and `pc_delta=...` for downstream
aggregation:

```
RESULT: red frame=283 total=417 orig_pc=0x... decomp_pc=0x... \
        class=drift pc_delta=4 components=r1,pc,ewram,iwram
```

## Workflow

Use lockstep as a *second-stage* check, not primary:

1. `per_patch_last_frame.sh` — fast PASS/FAIL on end-state. If FAIL,
   investigate. If PASS, continue.
2. `make verify` — semantic per-call check. If FAIL, investigate.
3. `bn6f-track lockstep` — deeper transient-state check. If
   `class=drift`, accept. If `class=bug`, investigate.

The first two filter out 99% of cases without needing lockstep.
Lockstep is reserved for "patch passes everything cheap; is there a
mid-bk2 transient bug that just happens to converge?"

## Fundamental tension

There's no way to make per-frame byte-parity work for a
partially-trampolined build. The trampoline mechanism necessarily
adds cycles, which necessarily shifts VBlank-relative timing, which
necessarily produces tiny persistent state divergence at frame
boundaries. The math doesn't allow otherwise.

The eventual no-trampoline build (all functions in C, linker assigns
addresses) will have zero drift and per-frame lockstep will be
meaningful again as the authoritative check.

## Related

- `docs/verification.md#drift-vs-bug-the-trampoline-cycle-overhead-problem`
- `docs/pitfalls/02-trampoline-cycle-drift.md`
- Memory: [[trampoline_cycle_drift]]
