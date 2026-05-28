# 12 — recvideo and framebuf produce different decoded pixels

**Class:** verification model / tooling bug
**Severity:** misleading mp4 PSNR signal
**Status:** open — root cause not yet found

## Symptom

Run the same orig ROM through `bn6f-track recvideo` for 16441 tutorial
frames → mp4. Extract frame 100 from that mp4 via ffmpeg. Get
sha1 `42e0a5332e39`.

Run `bn6f-track framebuf` with N=100 for the same orig ROM and savestate.
Get sha1 `4a8eeb12aa87`.

The two should be identical (same emulator state, same frame number),
but they differ — by 66% of bytes at frame 100, with average pixel
delta of 96/255.

## Why (working hypothesis)

Best guess: `recvideo`'s frame 0 captures a stale framebuffer that
existed before the savestate was loaded, OR there's an off-by-one
in the encoder's frame numbering vs the emulator's runFrame count.

Concretely:

- `recvideo`'s `start_recording` calls `FFmpegEncoderInit` →
  `FFmpegEncoderSetVideo` → ... → `FFmpegEncoderOpen` → `setAVStream`
- Then `start_recording` sets `frameskip=0` and the encoder hook
  starts capturing frames
- The very first `run_frame()` call might capture a framebuffer that
  hasn't been redrawn since before the savestate load

`framebuf`'s two-phase approach (frameskip=max for 0..N-2,
frameskip=0 for last frame) doesn't have this problem because the
final `run_frame()` always renders cleanly.

Not yet proven. The frame counts in both flows match (`nb_frames=16441`
for tutorial in both), so it's not a length issue.

## How to detect

Compare extracted-from-mp4 PPM against framebuf PPM:

```sh
bn6f-track framebuf rom.gba 100 /tmp/fb.ppm --input bk2.input --state bk2.ss
bn6f-track recvideo rom.gba 100 /tmp/rv.mp4 --input bk2.input --state bk2.ss
ffmpeg -y -i /tmp/rv.mp4 -vf "select=eq(n\,99)" -frames:v 1 /tmp/rv_extract.ppm
cmp -s /tmp/fb.ppm /tmp/rv_extract.ppm && echo MATCH || echo DIFFER
```

If DIFFER, this pitfall is active.

## Fix (workaround)

For correctness checks involving raw pixel comparison, **use framebuf**.
Reserve `recvideo` for visual review mp4s.

The `per_patch_last_frame.sh` script uses `framebuf` for both orig and
decomp PPM extraction — the comparison is honest.

PSNR-based comparison via `ffmpeg` on the mp4 outputs of `recvideo`
will give bogus results because the orig and decomp mp4s both have
this bias. We tried adding PSNR as a phase in `per_patch_videos.sh`
and got 12-20 dB across all patches (universal "bad" signal), then
removed the phase after discovering this pitfall.

## Fix (root cause)

Not yet implemented. Suspected fixes:

1. Pre-run one frame at the start of `recvideo` with PPU on before
   the encoder hook starts capturing. Flushes any stale framebuffer.
2. Investigate the `setAVStream` hook timing; ensure it sees the
   first *rendered* frame, not a pre-render snapshot.

Lower priority than the active sweep since `framebuf` already gives
the honest correctness signal. mp4s are visual-only.

## Related

- `tools/bn6f-track/src/main.rs::recvideo`
- `tools/bn6f-track/src/main.rs::framebuf`
- `tools/bn6f-track/src/main.rs::start_recording`
- `docs/pitfalls/10-libx264-nondeterministic.md`
- `docs/pitfalls/11-lossy-amplification.md`
