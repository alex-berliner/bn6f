# 19 — only VBlank IRQ fires during gameplay

**Class:** mGBA / emulator (useful constraint)
**Severity:** simplifies cycle-drift analysis
**Status:** confirmed empirically via `bn6f-track irqdump`

## Symptom

Not a bug — a useful invariant. If you assume HBlank, Timer, DMA, or
Keypad IRQs might fire and complicate cycle-drift analysis, you'd
overestimate the surface area. They don't fire during BN6F gameplay.

## Why

BN6F sets `IE = 0x2005` at boot and leaves it there for the entire
game:

- bit 0 (VBlank): enabled, fires every frame
- bit 2 (VCount): enabled, but LYC match is never set up → never raised
- bit 13 (GamePak): enabled, fires only on cartridge insertion/removal
  → never raised under emulation

bits 6 (Timer3) and 7 (Serial) toggle on briefly during boot setup
but immediately get masked out — they don't fire during normal play.

All other IRQ bits (HBlank, Timer 0-2, DMA 0-3, Keypad) are masked
throughout.

Confirmed empirically with `bn6f-track irqdump build/bn6f_orig.gba
5000 --input intro.input --state intro.ss --every 500`:

```
IE = 0x2005 {VBlank, VCount, GamePak}   (steady-state)
  VBlank   — fires every frame (4991/4991)
  VCount   — enabled, never raised
  GamePak  — enabled, never raised
```

## Implication for cycle drift

Cycle drift exposure surface is **VBlank-relative only**. That
narrows the things to worry about:

- We don't need to model HBlank-relative races
- Timer-driven sound mixing isn't affected by mainline cycle drift
- DMA-completion IRQs don't fire — no DMA-related races
- Keypad input handling happens via polling, not IRQ, so input edge
  detection isn't IRQ-cycle-sensitive

The only race condition class is: "is mainline still running when
VBlank fires?" That's what trampoline cycle drift can trigger.

## Implication for verification

If the game state diverges in lockstep at a moment when CPU is in
the IRQ handler (e.g. PC in 0x03005Bxx — the IWRAM IRQ master
handler), it's a VBlank-handler-related issue (which we expect under
drift).

If divergence is in a Timer or DMA context, something else is wrong —
the game isn't supposed to be there.

## When this matters

Mostly when analyzing lockstep divergences. Knowing only VBlank fires
lets you rule out "maybe a Timer IRQ ran" as an explanation.

Also when designing harness instrumentation: don't bother hooking
HBlank or Timer interrupts; nothing fires there.

## Related

- `tools/bn6f-track/src/main.rs::irqdump`
- Memory: [[irq_inventory_bn6f]]
- `docs/pitfalls/02-trampoline-cycle-drift.md`
