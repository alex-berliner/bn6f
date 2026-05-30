# 06a — Correctness oracle

## What it is today

Per-frame SHA256 over the visible 240×160 framebuffer. Pass = byte-
identical to orig every frame of every bk2. Pixels only.

## The problem

The byte-identical-pixels rule can't distinguish a **logic bug** from a
**timing artifact**. A trampoline adds ~6 cyc/call ([[trampoline_cycle_drift]]);
on a VBlank-tight frame that shifts what the PPU latches → a different
frame that is NOT a correctness error. The oracle flags both identically.
We've also gone deep into the weeds on video/pixel comparison generally.

## Verdict (2026-05-30)

**CHANGE DIRECTION — go back to memory / full-emulator-state diffing,
and attack the VBlank issue head-on instead of working around it.**

- Move the oracle from "pixels match" toward **RAM / full emulator state
  byte-parity** (this also subsumes audio, 06d). State parity is the
  stronger, less timing-fragile signal we had with the old approach.
- **Don't paper over drift — eliminate its cause.** The Feature 2
  relocation strategy (aggressively relocate symbols so hotpath functions
  don't need trampolines) is, in the user's view, the best shot at real
  full-RAM parity: no trampoline on the hot path → no per-call cycle cost
  → no VBlank drift → state parity becomes achievable.
- Treat the pixel/video path as **informal review only** (see 06h), not
  the correctness signal.

### Open questions
- [ ] Which state to diff: full savestate bytes, or scoped RAM regions
      (EWRAM/IWRAM/VRAM/OAM/IO)? Full state is strictest but may include
      benign-divergence noise (timers, RNG seeds) — needs investigation.
- [ ] At what cadence — per-frame state hash, or per-call (the old
      dispatcher-boundary snapshot idea, [[decomp_harness_dispatcher_verification]])?
- [ ] Sequencing: full-state parity may only be reachable AFTER the
      relocation work lands. Until then, what's the interim oracle?

---
_Last updated: 2026-05-30 12:10:07 -0400_
