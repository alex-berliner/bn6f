# Pitfalls reference — what to avoid and how

Catalog of bugs / footguns encountered during BN6F decomp, with the
workaround or method we use to avoid each. Useful when onboarding,
when verify fails inexplicably, or when adding a new C port.

See [docs/verification.md](verification.md) for the verification model
and [issues/decomp-blockers.md](../issues/decomp-blockers.md) for open
items each one corresponds to.

## Build-system pitfalls

### agbcc union / small-struct +4-byte padding

**Symptom:** field access via `eToolkit->BattleStatePtr->Unk_32`
resolves to wrong byte offset (typically 8 bytes too far).

**Why:** agbcc (gcc 2.9-arm) gives every C `union` and small `struct`
a minimum size of 4 bytes and 4-byte alignment. Each such union in a
generated header shifts every following field by +2 bytes. BattleState
has 3 unions before offset 0x32, so all fields at/after offset 0x18
shift by +8.

**Fix:** for affected structs, use raw byte offsets with explicit
casts instead of typed field access:

```c
u16 *p = (u16 *)((u8 *)eToolkit->BattleStatePtr + 0x32);
*p &= (u16)~mask;
```

The Toolkit struct itself is clean (no unions), so accessing
`eToolkit->FieldPtr` works fine; only the dereferenced pointee types
with unions need the workaround.

**Long-term:** issues/decomp-blockers.md #11 — regenerate headers
without C unions.

### Trampoline cycle drift

**Symptom:** patches pass per-call semantic check but fail per-frame
lockstep with small persistent-state diff (typically 1 byte).

**Why:** every `decomp_trampoline` adds ~6 cycles per call. Cumulative
overhead can push mainline past the VBlank deadline. When mainline is
mid-buffer-write at VBlank, the handler reads in-progress staging
buffer and observes different bytes vs orig.

**Fix:** accept drift-class lockstep failures as expected. Use
*last-frame PPM* and *combined-test* as the correctness signals —
end-state convergence is what matters. See
[trampoline-cycle-drift memory](../.claude/projects/.../memory/trampoline_cycle_drift.md)
and [docs/verification.md](verification.md#drift-vs-bug-the-trampoline-cycle-overhead-problem).

### LR-bit-bx mode-switch bug

**Symptom:** decomp ROM crashes shortly after invoking a converted
function that's referenced indirectly in ASM.

**Why:** `mov lr, pc; bx rN` callers (the thumb-1 indirect-call
sequence) leave LR with bit 0 = 0. agbcc's `pop+bx` epilogue then
interworks to ARM mode and lands in stack/data garbage.

**Fix:** wrap any C function referenced indirectly (search:
`.word symbol` or `.word symbol+1` in `asm/`) with the
`DECOMP_VTABLE_WRAPPER` macro from `src/c/types.h`.

### gcc r10 save/restore around `bl` calls

**Symptom:** C codegen has extra `push {r3}; pop {r3}; mov sl, r3`
shuffles around `bl` calls (~8 cycles per call).

**Why:** the `register u8 *r10p asm("r10")` + `asm volatile("" : "=r"(r10p))`
pattern makes gcc treat r10 as caller-preserved across function calls,
so it pushes/restores around every `bl`.

**Fix:** when you only need to *read* r10 (the Toolkit pointer), use
the absolute address instead:

```c
#include "EWRAM.h"   // defines eToolkit = (Toolkit *)0x020093B0
u8 *gs = (u8 *)eToolkit->GameStatePtr;
```

This compiles to a `ldr` from a literal pool instead of a register
shuffle.

### r3 clobber by `decomp_trampoline`

**Symptom:** caller of patched function has wrong r3 after the call.

**Why:** standard trampoline does `ldr r3, =target+1; bx r3` —
overwrites r3 with the literal-pool address.

**Fix:** use `decomp_trampoline_r3safe` if any caller relies on r3
surviving (4-arg ASM callees). Adds 4 more bytes and ~2 cycles per
call.

**Note:** was tested-and-falsified as the cause of ByteFill drift —
not a common issue, but documented in case.

### agbcc C89-only

**Symptom:** mixed declarations after statements → compile error.

**Fix:** declare all locals at top of block. No `for (int i = 0;...)`
either — use `int i; for (i = 0; ...)`.

### Stale flags-file mtime

**Symptom:** make uses wrong/empty conditional compilation despite
the manifest being correct.

**Why:** `mv` preserves mtime. A restored manifest can appear older
than `build/decomp_flags.txt` → make thinks flags are up-to-date and
skips regen.

**Fix:** `clean-conditional-objs` removes the flags file. Use
`cp + touch` pattern, never `mv`, when restoring the manifest.

### Manifest drift from failed trap restore

**Symptom:** `tools/decomp_manifest.txt` accumulates extra entries
between runs.

**Why:** interrupted per-patch scripts leave the manifest in a
modified state if the trap doesn't fire (Ctrl-C race, kill -9, etc.).

**Fix:** `git checkout tools/decomp_manifest.txt && touch
tools/decomp_manifest.txt` between runs. Scripts sanity-check ≥100
entries before backing up.

## Verification pitfalls

### Per-frame strict lockstep gives false positives

**Symptom:** lockstep reports patches as broken even when they're
semantically correct.

**Why:** trampoline cycle drift (see above) produces tiny persistent
state divergence even for byte-equivalent C codegen.

**Fix:** use the drift classifier in `bn6f-track lockstep`:
- `class=drift` → expected, not a bug
- `class=bug` → real C-port issue, investigate
- `class=mixed` → manual inspection

Or rely on *last-frame PPM* as the unambiguous signal (drift converges
by end of bk2 for working patches).

### libx264 is non-deterministic at byte level

**Symptom:** rendering orig twice produces different mp4 bytes
(different md5/sha) despite identical pixel input.

**Why:** multi-threaded x264 has non-deterministic thread interleaving
that affects rate-distortion decisions. Decoded pixels are identical
(PSNR=inf) but encoded bytes differ.

**Fix:** don't `cmp -s` lossy mp4s for correctness. Use PPM
byte-compare (raw, no encoder) or use FFV1 lossless if mp4 byte
comparison is required.

### Lossy compression amplifies tiny pixel diffs

**Symptom:** a 0.6% real pixel diff shows up as a 50% mp4 size delta.

**Why:** lossy codecs use cascading rate-distortion decisions —
a few different pixels in frame N cascade into different macroblock
partitioning across hundreds of subsequent frames.

**Fix:** for honest size-delta signal, use lossless encoding
(FFV1/Matroska — mGBA's FFmpegEncoder special-cases FFV1 to set
`lossless=1, crf=0`). Files are ~100× larger but the delta scales
linearly with actual pixel-difference count. Or skip size comparison
entirely and use PPM byte-compare.

### `recvideo` ≠ `framebuf` at the pixel level

**Symptom:** extracting frame N from `recvideo` output gives different
pixels than `framebuf` at frame N for the same emulator state.

**Why:** open bug. Likely off-by-one in frame indexing or stale
framebuffer captured at frame 0.

**Fix:** use `framebuf` (direct PPM dump) for correctness checks.
Reserve `recvideo` for visual-review mp4s only. Don't trust mp4-frame
extraction for pixel comparisons.

### Last-frame PPM is necessary but not sufficient

**Symptom:** a converges-by-end bug (transient mid-bk2 divergence
that happens to resolve) slips through last-frame check.

**Fix:** combine with a parallelized `lockstep` pass over the
validated set as a deeper second-stage check. Lockstep with drift
classifier catches transient `class=bug` divergences that last-frame
misses.

### Tutorial bk2 doesn't exercise all functions

**Symptom:** a patch passes the 3 bk2 fixtures but fails in code paths
not covered.

**Fix:** acknowledged limitation. Combined-test (N patches enabled
together) extends coverage but doesn't add new paths. Long-term: more
bk2 fixtures covering shop, menu, save, multiplayer paths.

## Test infrastructure pitfalls

### Concurrent script runs collide

**Symptom:** both scripts modify `tools/decomp_manifest.txt`
simultaneously → wrong patch sets, partial manifests, Bus errors in
`bn6f-track` from corrupt ROMs.

**Fix:** only run one manifest-touching script at a time. PID-stamped
temp files (`$BACKUP=/tmp/m_backup_$$.txt`) defend against orphaned
leftovers.

### Render every frame to PPM when only final is needed

**Symptom:** `framebuf` runs 5× slower than needed for last-frame
checks.

**Fix:** two-phase `framebuf` — `frameskip=max` for frames 0..N-2
(headless emulation, no PPU output), `frameskip=0` for the final
frame only. ~8× speedup confirmed on tutorial.

### Stale build artifacts cached across patch changes

**Symptom:** changing manifest doesn't propagate; build uses old C
objects.

**Fix:** `make clean-conditional-objs` between per-patch builds.
Removes manifest-dependent objects.

## mGBA / emulator pitfalls

### `mTimingCurrentTime` returns wrapping int32

**Symptom:** cycle delta computations show absurd values across long
runs.

**Fix:** use signed `wrapping_sub` for deltas. Switch to
`mTimingGlobalTime` (uint64) if precision needed across many frames.

### Only VBlank IRQ fires during gameplay

**Symptom:** none, but useful constraint to remember.

**Why:** IE=0x2005 (VBlank + VCount + GamePak); VCount and GamePak
never raise during normal play. Confirmed via `bn6f-track irqdump`.

**Implication:** cycle drift exposure surface is VBlank-relative only.
No HBlank, Timer, DMA, or Keypad interrupt races to worry about.

### mGBA `FFmpegEncoder` API doesn't expose x264 preset / qp

**Symptom:** can't get true lossless x264 from `recvideo`.

**Fix:** use FFV1 codec instead of libx264. mGBA's encoder
special-cases FFV1 to set `lossless=1, crf=0` automatically. Switch
container to Matroska (`.mkv`).
