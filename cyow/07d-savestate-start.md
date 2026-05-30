# 07d — savestate-start fixtures

## What it is
2 of 3 fixtures (`intro`, `intro_to_end_tutorial`) resume from a
`Core.bin.zst` mGBA savestate rather than booting. Only `coldboot`
starts from power-on.

## Why it matters
- A savestate skips the boot/IRQ-init path entirely — those fixtures
  give zero evidence about boot-time code.
- Worse (with 07c): those savestates were produced under SkipBios, so
  they bake in a non-real-BIOS machine state. Re-recording for 06e isn't
  "flip a flag" — the **savestates themselves must be regenerated** from
  a real-BIOS cold boot, or discarded in favor of cold-boot-rooted runs.

## Tension
Savestate-start exists for speed (skip minutes of boot/menus to reach the
interesting scene). Removing it entirely makes fixtures long; keeping it
needs real-BIOS-rooted savestates.

## Rating
**KEEP savestate-start — real BIOS does NOT require coldboot.**
(2026-05-30)

Answer to the question: a savestate restores full machine state past
boot, so you do **not** need to coldboot. Requirements are only: (1) the
real BIOS is present at restore time (game makes SWI calls during
gameplay that need real BIOS bytes), and (2) the savestate was itself
created on a real-BIOS run so its captured state is consistent. Since the
user is regenerating all bk2s with BIOS enabled, both hold automatically
— savestate-start fixtures are fine and stay (they're the speed win).

- [ ] When regenerating, ensure savestates are captured from a
      real-BIOS run (not a SkipBios one).
- No concern about sanctity of current tests — they're being replaced.

---
_Last updated: 2026-05-30 12:41:29 -0400_
