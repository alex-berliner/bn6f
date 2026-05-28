# Pitfalls reference — what to avoid and how

Catalog of bugs / footguns encountered during BN6F decomp, with the
workaround or method we use to avoid each. Each entry below links to
a detailed write-up under `pitfalls/`.

| # | Pitfall | Class |
|---|---|---|
| [01](pitfalls/01-agbcc-union-padding.md) | agbcc union / small-struct +4-byte padding | build-system |
| [02](pitfalls/02-trampoline-cycle-drift.md) | Trampoline cycle drift | verification model |
| [03](pitfalls/03-lr-bit-bx-bug.md) | LR-bit BX mode-switch bug | build-system |
| [04](pitfalls/04-gcc-r10-save-restore.md) | gcc r10 save/restore around bl calls | build-system |
| [05](pitfalls/05-r3-clobber-trampoline.md) | r3 clobber by standard decomp_trampoline | build-system |
| [06](pitfalls/06-agbcc-c89-only.md) | agbcc is C89-only | build-system |
| [07](pitfalls/07-stale-flags-file-mtime.md) | Stale flags-file mtime | test infrastructure |
| [08](pitfalls/08-manifest-drift.md) | Manifest drift from failed trap restore | test infrastructure |
| [09](pitfalls/09-lockstep-false-positives.md) | Per-frame strict lockstep false positives | verification model |
| [10](pitfalls/10-libx264-nondeterministic.md) | libx264 is non-deterministic at byte level | verification model |
| [11](pitfalls/11-lossy-amplification.md) | Lossy compression amplifies tiny pixel diffs | verification model |
| [12](pitfalls/12-recvideo-framebuf-mismatch.md) | recvideo ≠ framebuf at pixel level | verification model |
| [13](pitfalls/13-last-frame-not-sufficient.md) | Last-frame PPM necessary but not sufficient | verification model |
| [14](pitfalls/14-bk2-coverage-gaps.md) | Tutorial bk2 doesn't exercise all functions | verification model |
| [15](pitfalls/15-concurrent-script-collision.md) | Concurrent script runs collide on shared state | test infrastructure |
| [16](pitfalls/16-framebuf-render-every-frame.md) | Rendering every frame in framebuf when only last is needed | test infrastructure |
| [17](pitfalls/17-stale-conditional-objs.md) | Stale conditional-compiled C objects after manifest change | test infrastructure |
| [18](pitfalls/18-mtimingcurrenttime-wrap.md) | mTimingCurrentTime returns wrapping int32 | mGBA |
| [19](pitfalls/19-only-vblank-fires.md) | Only VBlank IRQ fires during gameplay (constraint) | mGBA |
| [20](pitfalls/20-mgba-encoder-api-limits.md) | mGBA FFmpegEncoder API doesn't expose x264 preset/qp | mGBA |

See `docs/verification.md` for the verification model and
`issues/decomp-blockers.md` for open items each entry corresponds to.

## Quick lookup by symptom

- **Patch passes verify but fails lockstep**: [02](pitfalls/02-trampoline-cycle-drift.md), [09](pitfalls/09-lockstep-false-positives.md)
- **C field access uses wrong byte offset**: [01](pitfalls/01-agbcc-union-padding.md)
- **Decomp ROM crashes after function call**: [03](pitfalls/03-lr-bit-bx-bug.md)
- **C code has unnecessary push/pop r3 around bl**: [04](pitfalls/04-gcc-r10-save-restore.md)
- **Caller of patched fn reads wrong r3**: [05](pitfalls/05-r3-clobber-trampoline.md)
- **agbcc parse error on modern C syntax**: [06](pitfalls/06-agbcc-c89-only.md)
- **make decompile uses stale flags**: [07](pitfalls/07-stale-flags-file-mtime.md), [17](pitfalls/17-stale-conditional-objs.md)
- **Manifest has extra entries**: [08](pitfalls/08-manifest-drift.md)
- **mp4 byte-cmp inconsistent**: [10](pitfalls/10-libx264-nondeterministic.md), [11](pitfalls/11-lossy-amplification.md)
- **Bus error in bn6f-track**: [15](pitfalls/15-concurrent-script-collision.md)
- **Cycle delta computes to nonsense**: [18](pitfalls/18-mtimingcurrenttime-wrap.md)
