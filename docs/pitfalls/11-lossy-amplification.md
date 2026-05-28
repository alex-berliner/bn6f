# 11 — lossy compression amplifies tiny pixel diffs

**Class:** verification model
**Severity:** size-delta signal overstates magnitude of real divergence
**Status:** understood; use lossless for size compare

## Symptom

You render `orig.mp4` and `decomp.mp4` for some patch. Sizes:

- orig: 3,512,853 bytes
- decomp: 7,170,590 bytes (+104% larger)

Interpretation seems obvious: decomp is wildly wrong, every frame is
visibly different. But other signals (last-frame PPM, lockstep) say
the patches pass. What gives?

## Why

Lossy codecs use **cascading rate-distortion decisions**. The encoder
allocates bits across frames based on what it sees in earlier frames.
A small pixel difference in frame N:

1. Changes the macroblock partitioning chosen for frame N
2. Which changes the residual the encoder needs to compress
3. Which changes how many bits get allocated to frame N
4. Which changes the bit budget for frames N+1, N+2, ...
5. Which changes their macroblock partitioning
6. ...

A few pixel differences in frame 100 cascade into hundreds of frames
having different rate-distortion choices. The encoded size delta is
many multiples of the actual pixel-difference area.

Empirical example: `battle_setFlags` patch caused a real 0.6% pixel
diff in tutorial (measured via lossless FFV1 = `+1.6MB / 275MB`). The
same patch encoded with lossy x264 CRF 28 produced a 50% size delta
(`3.5MB → 7.17MB`). The lossy signal overstated the divergence by ~85×.

## How to detect

If your "broken" patch shows a huge mp4 size delta but other checks
pass, suspect this amplification. Render with FFV1 lossless to get
the honest delta:

```sh
# Temporarily switch recvideo to FFV1 (matroska container)
# in tools/bn6f-track/src/main.rs, then:
bn6f-track recvideo build/bn6f_orig.gba 16441 /tmp/orig.mkv ...
bn6f-track recvideo build/bn6f_decomp.gba 16441 /tmp/decomp.mkv ...
ls -la /tmp/orig.mkv /tmp/decomp.mkv
```

In lossless, the size delta scales linearly with pixel-difference
count. A 1% size delta means roughly 1% of pixels differ.

## Fix

For correctness signal that "scales honestly":

| Need | Tool |
|---|---|
| PASS/FAIL on final pixels | PPM byte-compare via `framebuf` |
| Pixel-equality through whole bk2 | FFV1 lossless mp4 + cmp |
| Magnitude of real divergence | FFV1 lossless mp4, divide by file size |
| Visual review | Lossy mp4 (small, fine for human eyes) |

The project uses PPM byte-compare for correctness and lossy mp4 for
visual review. The lossless FFV1 path is implemented (`recvideo`
shipped that codec briefly) and can be toggled back when needed.

## Implication for mp4 size as a canary

mp4 size as a "did anything change" canary is *biased high* — a tiny
real divergence shows up as a huge delta. Useful for spotting some
divergence, useless for estimating its magnitude.

Don't rank patches by mp4 size delta. Don't assume larger delta = worse
divergence. Trust the lossless or pixel-level signals.

## Related

- `docs/pitfalls/10-libx264-nondeterministic.md`
- `tools/bn6f-track/src/main.rs::start_recording` (codec choice)
- We briefly shipped FFV1 (commit `5b4d4700`), reverted in `0bfced0a`
  because lossless files were too big for remote review. The honest
  size-delta signal is still available by re-enabling that codec
  selection.
