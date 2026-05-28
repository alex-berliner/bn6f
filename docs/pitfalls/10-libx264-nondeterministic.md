# 10 — libx264 is non-deterministic at byte level

**Class:** verification model / test infrastructure
**Severity:** misleading PASS/FAIL signal from mp4 comparison
**Status:** documented; use PPM or FFV1 for byte-equal compare

## Symptom

You render the same orig ROM through `bn6f-track recvideo` twice with
identical settings. The two output mp4 files have **different
md5/sha** despite encoding identical pixel content.

Worse: you use `cmp -s orig.mp4 decomp.mp4` as a per-patch
correctness check, see it report differences, and conclude the patch
is broken. But extracting individual frames from both mp4s shows the
pixels are identical (PSNR=inf).

## Why

libx264's multi-threaded encoder makes rate-distortion decisions
based partly on thread interleaving — which depends on OS scheduling
and is not byte-deterministic across runs.

Empirical test: 3 fresh renders of the same orig coldboot through
`recvideo`:

```
run 1: md5 4064850367ff  121514 bytes
run 2: md5 0837e7e652a1  121524 bytes
run 3: md5 3c877055a55d  121535 bytes
```

Decoded frame 50 from each:

```
sha1(run1 frame 50) = e970111f849a33a2...
sha1(run2 frame 50) = e970111f849a33a2...   (identical)
```

So the encoder's *output bytes* differ but the *decoded pixels* are
identical. `cmp` on mp4s sees the byte difference and screams; the
underlying content is the same.

## Fix

Don't use `cmp -s` on lossy mp4s as a correctness signal.

For honest byte-equal pixel comparison:

| Approach | Pros | Cons |
|---|---|---|
| **PPM byte-compare via `framebuf`** | Definitive (raw pixels, no encoder) | Last-frame only, or need multi-frame scripting |
| **PSNR comparison via ffmpeg** | Works on lossy mp4s, definitive when PSNR=inf | Decoder noise can shift PSNR slightly; needs threshold |
| **FFV1 lossless mp4** | Bytes match if pixels match | Files ~100× larger than lossy |

The project's standard correctness checks use the first option
(`per_patch_last_frame.sh` extracts the final framebuffer as a PPM
via `bn6f-track framebuf`, then `cmp`s).

## Implication for mp4 reviews

The mp4s in `build/videos/` are for visual review only. Two patches
producing mp4s with different md5s might be functionally equivalent
(just encoded differently due to thread interleaving), not actually
divergent. Don't use mp4 size or hash as the canary.

## Could we make libx264 deterministic?

In principle yes — `-x264-params threads=1` would single-thread the
encoder. But mGBA's `FFmpegEncoderSetVideo` API doesn't expose x264
preset / opts, so we can't pass that through. Switching to FFV1
(which mGBA *does* configure for lossless) bypasses the problem
entirely at the cost of much larger files.

For now: live with non-determinism for visual review; use PPM for
correctness.

## Related

- `docs/pitfalls/12-recvideo-framebuf-mismatch.md`
- `tools/per_patch_last_frame.sh` (the right way)
- `tools/per_patch_videos.sh` (visual review only)
