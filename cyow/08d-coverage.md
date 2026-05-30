# 08d — Single canary / single failure mode

## Finding
One canary, one mutation (XOR pixels). It proves the validator catches a
gross **pixel** divergence. It proves NOTHING about the failure classes
we actually fear:
- **audio-only** corruption (06d — audio isn't hashed at all, so a canary
  there would expose a real, current hole)
- **VBlank/timing drift** (06a)
- **state change with no pixel change** (the whole reason 06a wants
  full-state parity)

## Direction
- [ ] One canary **per oracle dimension** — pixel, audio, full RAM/state,
      timing. Each must be caught by the oracle that's supposed to cover
      it (and a state-only canary should be MISSED by a pixel oracle and
      CAUGHT by a state oracle — that's the test that proves 06a's
      upgrade earned its cost).
- [ ] Canaries become the acceptance test for the 06a oracle change.

## Rating
**OK — add more canaries later; scope is harness-validation, not ROM.**
(2026-05-30) Important framing from the user: canaries validate the
**effectiveness of the harness itself**, not the correctness of the ROM.
One is enough to start; add a canary per oracle dimension (pixel, audio,
state, timing) as those oracles come online — each new oracle ships with
the canary that proves it works. Not urgent now.

---
_Last updated: 2026-05-30 13:02:56 -0400_
