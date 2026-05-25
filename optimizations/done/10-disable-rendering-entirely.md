# Disable rendering entirely (no PPU, no video buffer)

**Status:** Option A implemented; B/C deferred
**Impact:** ★★★ (high, conditional — depends how much of libmgba's
per-frame cost is PPU + buffer-writes vs CPU emulation)
**Effort:** low (option A) → high (option C, fork)

## Problem

Frameskip=9 (see [02](02-frameskip-headless.md)) renders 1 of every 10
frames. We still:

- Allocate the 256×160×4 video buffer per `Core::new`.
- Pay full PPU per-scanline rendering on every 10th frame
  (BG layer compositing, sprite step, blending, mosaic).
- Run all the rendering setup that fires regardless of frameskip
  (vcount scheduling, scanline event timers).

The harness is **always headless**. No display, no screenshot, no path
that reads the video buffer. Rendering even one frame in ten is pure
waste.

## Approach — three options, escalating cost

### Option A: frameskip = i32::MAX
Cheapest possible try. `gba/video.c` decrements `frameskipCounter`
every frame and resets to `frameskip` when it goes negative. With
`opts.frameskip = i32::MAX`, the counter would take ~2 billion frames
to wrap → effectively *never* renders. One-line change to the existing
`opts.frameskip` assignment in `Core::new`.

Limitation: still allocates the video buffer; still runs the PPU
event scheduling and DISPSTAT bookkeeping. Saves the per-scanline
draw work (drawScanline / finishFrame) but not the rendering
*infrastructure*. Should be tried first because it's free to
measure.

### Option B: register a null renderer
libmgba's video has a renderer interface — `video->renderer` is a
vtable of `init / deinit / writeVideoRegister / drawScanline /
finishFrame / getPixels / etc.` The default for the GBA core is
`GBAVideoSoftwareRenderer` (`gba/renderers/video-software.c`). We
could register a null renderer whose methods are all no-ops.

This eliminates the per-scanline draw work cleanly without depending
on the frameskip counter, *and* lets us skip allocating the 256×160×4
framebuffer (or use a 16-byte stub).

Implementation: the `setVideoBuffer` callback on `mCore` is called
*through* the renderer's `setBuffer`. If we install our own renderer
before that call, all subsequent video operations no-op. Likely
requires exposing `gba->video.renderer` field write through the
binding, plus a Rust struct that satisfies the C vtable. Not a fork
— uses the existing renderer hook — but invasive enough that it's
medium-effort.

### Option C: fork libmgba and strip video
For an aggressive headless build: patch out the PPU event scheduling
entirely, leave only the DISPSTAT register writes (which the game
reads for vblank polling) and the VBlank IRQ firing. Audio mixer
could also be stripped. Possibly: skip the renderer module compile
entirely.

User has indicated willingness to fork libmgba in service of
optimization, which makes this viable. The split would live at
`tools/libmgba/` (currently a binary distribution); a forked source
build would slot into the same path.

Expected win shape: if PPU + audio + rendering infrastructure is, say,
20% of `runFrame` cost, this gets all 20% back vs frameskip=9's ~18%.
The marginal gain over option B is small unless the audio mixer / event
scheduler turn out to be unexpectedly heavy.

## Implementation notes

- **Game timing must not change.** DISPSTAT updates, vcount ticking,
  VBlank IRQ generation, frame-end callbacks — all of these are
  game-visible and must keep firing. We're killing the *render* path,
  not the *timing* path.
- The right validation: run `make verify` and `make verify-spam` after
  each step; if any pairs go from PASS to FAIL it means we accidentally
  killed something the game observes.
- Order to try: A first (measure with a workload that actually exercises
  the PPU — see [02](02-frameskip-headless.md)'s "real benchmark"
  caveat). If A shows real savings, try B. Only fork (C) if B isn't
  enough.
- Cross-references: this supersedes [02](02-frameskip-headless.md)
  if implemented. If A works, [02] becomes obsolete and can be removed
  or marked abandoned.

## Results

Option A landed: default `(*raw).opts.frameskip = i32::MAX` (env-var
override still honored). The `frameskipCounter` (signed decrement,
reset on negative) effectively never reaches zero, so per-scanline
draw + `finishFrame` are skipped for the lifetime of the run.

`make verify` (bk2 harness, 4154 pairs):

| State | Wall | Δ |
|---|---|---|
| Baseline (frameskip=9) | 1:51.60 | — |
| Option A (frameskip=i32::MAX) | 1:49.98 | -1.5% |

Marginal. The prior frameskip=9 default already captured ~90% of the
PPU work; squeezing the last 1/10 doesn't move the needle. All 4154
pairs still pass — no PASS→FAIL regressions, confirming no game-side
code observes the missing frames.

Option B (null renderer) deferred: with Opt 04 (direct CPU register
reads) delivering -41% on the same workload, the residual PPU
infrastructure cost (event scheduling + framebuffer alloc) is no
longer worth a Rust→C vtable shim. Revisit if a future workload
spends measurable time inside the PPU event scheduler.

Option C (libmgba fork) deferred indefinitely — Option B is the
prerequisite probe for whether C would even pay back.
