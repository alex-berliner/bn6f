# 20 — mGBA FFmpegEncoder API doesn't expose x264 preset / qp

**Class:** mGBA / emulator
**Severity:** can't get true lossless or fast-preset x264 from `recvideo`
**Status:** workaround uses FFV1 codec (mGBA special-cases for lossless)

## Symptom

You want `recvideo` to produce truly lossless x264 mp4 (for honest
byte-equal pixel comparison) or to use the `ultrafast` preset (for
speed). Neither is achievable via the existing API.

## Why

mGBA's `FFmpegEncoderSetVideo` signature:

```c
bool FFmpegEncoderSetVideo(struct FFmpegEncoder*, const char* vcodec,
                           int vbr, int frameskip);
```

`vbr` is the only knob:

- `vbr > 0` → bit rate target (`-b:v <vbr>`)
- `vbr < 0` → CRF (`-crf <|vbr|>`)
- `vbr == 0` → libx264's default (CRF ~23)

For libx264 truly lossless, you need `-crf 0 -qp 0` and ideally a
specific preset. The API doesn't take a preset argument and `vbr=0`
doesn't trigger lossless — it falls through to libx264's default.

You can't pass arbitrary x264 options like `--qp=0` or `--preset=ultrafast`.

## Workaround

mGBA's FFmpegEncoder has a **special case for FFV1**:

```c
// from src/feature/ffmpeg/ffmpeg-encoder.c
if (encoder->video->codec->id == AV_CODEC_ID_FFV1) {
    av_opt_set(encoder->video->priv_data, "lossless", "1", 0);
    av_opt_set_int(encoder->video->priv_data, "crf", 0, 0);
    ...
}
```

So `vcodec = "ffv1"` automatically configures lossless. Combined with
the matroska container (`mkv`, which carries FFV1 cleanly):

```rust
let vcodec = CString::new("ffv1").unwrap();
let acodec = CString::new("flac").unwrap();
let container = CString::new("matroska").unwrap();
```

This gives true lossless output. Files are ~100× larger than lossy
x264 mp4 — for tutorial that's ~275 MB vs ~3.5 MB. Practical for
correctness analysis on a workstation; impractical for remote review.

The project currently ships libx264 CRF 28 mp4 (committed in
`0bfced0a` after a brief lossless FFV1 phase). To re-enable lossless,
change the codec strings in `tools/bn6f-track/src/main.rs::start_recording`.

## Fix (long term)

Could fork mGBA to expose preset / arbitrary x264 opts:

```c
// proposed new mGBA function
bool FFmpegEncoderSetVideoEx(struct FFmpegEncoder*, const char* vcodec,
                              int vbr, int frameskip,
                              const char* extra_opts);
```

Per the project's libmgba-mod permission ([[feedback-libmgba-mod-permission]]),
this is doable — clone source, patch, rebuild, install. The
~/Code/bn/bn6f/tools/libmgba/README.md documents the rebuild flow.

Not yet implemented because FFV1 + the current libx264 CRF 28 cover
the two use cases (true lossless + small viewable) we currently need.

## Related

- `tools/bn6f-track/src/main.rs::start_recording` (codec config)
- `tools/libmgba/README.md` (rebuild instructions)
- Memory: [[feedback-libmgba-mod-permission]]
- `docs/pitfalls/10-libx264-nondeterministic.md`
- `docs/pitfalls/11-lossy-amplification.md`
