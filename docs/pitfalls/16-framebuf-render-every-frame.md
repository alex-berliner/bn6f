# 16 — rendering every frame in framebuf when only the last is needed

**Class:** test infrastructure / performance
**Severity:** 8× slowdown on long bk2s
**Status:** fixed via two-phase rendering

## Symptom

`bn6f-track framebuf rom 16441 out.ppm --input tutorial.input` takes
~150 seconds. You only care about the last frame's PPM output. The
intermediate 16,440 frames are wasted work.

## Why

The PPU (pixel processor) draws scanlines as cycles advance through
the emulator. With frameskip=0, every frame's pixels are written to
the framebuffer. That costs ~1ms per frame.

For correctness checks (e.g. compare end-state PPM to orig), only
the final framebuffer matters. The intermediate framebuffer states
are computed and immediately overwritten.

## Fix

Two-phase rendering:

1. Run frames 0..N-2 with `frameskip=max` (PPU off, emulation continues
   but no pixel output)
2. Run frame N-1 with `frameskip=0` (PPU on, framebuffer populated)
3. Dump the final framebuffer

Implementation in `tools/bn6f-track/src/main.rs::framebuf`:

```rust
let set_frameskip = |val: i32| unsafe {
    let cfg_key = std::ffi::CString::new("frameskip").unwrap();
    mgba_sys::mCoreConfigSetIntValue(&mut (*core.raw).config, cfg_key.as_ptr(), val);
    let reload = (*core.raw).reloadConfigOption.expect("reloadConfigOption");
    reload(core.raw, cfg_key.as_ptr(), &mut (*core.raw).config);
};
for i in 0..n {
    if i == n.saturating_sub(1) {
        set_frameskip(0);
    }
    let mask = inputs[i] as u32;
    unsafe {
        set_keys(core.raw, mask);
        run_frame(core.raw);
    }
}
```

`Core::new()` already sets `BN6F_TRACK_FRAMESKIP=i32::MAX` (no
rendering) by default — so frames 0..N-2 run headless. We only need
to flip frameskip back to 0 for the final frame.

## Measured speedup

Tutorial bk2 (16441 frames):

- Before: ~150s (PPU on for all frames)
- After: ~18s (PPU on for last frame only)

~8× speedup. The per-patch last-frame sweep dropped from ~25 minutes
per batch to ~6 minutes.

## Why this doesn't work for recvideo

`recvideo` *needs* every frame's pixels to encode the mp4. Can't
skip them. So recvideo is stuck at the slow rate (~150s for tutorial)
unless we want a low-fps mp4.

For correctness checks though, `framebuf` is the right tool, and the
two-phase optimization makes it fast.

## Related

- `tools/bn6f-track/src/main.rs::framebuf`
- `tools/per_patch_last_frame.sh` (the consumer that benefits)
- Pitfall 12 (recvideo's frame-output quirks)
