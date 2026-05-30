# 06d — Audio validation

## What it is today

Audio is never validated — only the framebuffer is hashed. A conversion
that corrupts sound passes silently.

## Verdict (2026-05-30)

**SUBSUMED by full-emulator-state byte parity (06a).** No good
standalone idea for audio specifically; the only clean answer is to make
the oracle diff full emulator state (which includes the sound
hardware/driver state), so audio correctness falls out of 06a rather
than needing its own mechanism.

- [ ] Confirm that the chosen state-diff scope in 06a actually covers the
      audio driver state (m4a engine RAM, sound IO regs), or audio stays
      a blind spot.

---
_Last updated: 2026-05-30 12:10:27 -0400_
