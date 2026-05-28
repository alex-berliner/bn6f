# 02 — trampoline cycle drift

**Class:** verification model
**Severity:** false-positive failures in strict lockstep
**Status:** understood, classifier shipped, documented behaviour

## Symptom

A C port that's instruction-equivalent to its orig ASM still fails
`make verify-strict` (per-frame full-state lockstep) on at least one
bk2. The reported divergence is typically:

- a 1-byte persistent diff in EWRAM, palette, or OAM
- both PCs in the same broad code region (often both in BIOS `IntrWait`)
- PC delta small (a few bytes / 1-2 thumb instructions)

The drift classifier in `bn6f-track lockstep` labels these as
`class=drift`. They're expected, not real bugs.

## Why

Every `decomp_trampoline` adds ~6 cycles per call (load literal + bx
+ pipeline flush). The `_r3safe` variant adds ~12. A function called
~100 times per frame costs ~600-1200 extra cycles per frame — about
0.2-0.4% of the 280,896-cycle frame budget.

That tiny cost is normally absorbed by the BIOS `IntrWait` halt at
end of mainline work. But on tight frames where mainline is doing
significant work, the cycles add up enough that mainline can still be
running when VBlank fires. At that moment:

1. The VBlank IRQ handler interrupts mainline mid-work
2. Handler does OAM / palette DMA from staging buffers
3. Staging buffers are partially filled (mainline didn't finish)
4. Handler reads different bytes than orig at the same logical moment
5. PPU renders slightly different output

We proved this empirically with the ByteFill experiment (May 2026):
rewriting `ByteFill_c` as `__attribute__((naked))` inline asm
*instruction-identical* to orig still produced drift-class divergence
at coldboot frame 283. Swapping the trampoline to `_r3safe` shifted
the divergence to frame 281. The trampoline mechanism alone, with
zero C-codegen difference, produces persistent state divergence.

## How to detect

`bn6f-track lockstep` includes a classifier on every red:

```
RESULT: red frame=283 total=417 orig_pc=0x... decomp_pc=0x... \
        class=drift pc_delta=4 components=r1,pc,ewram,iwram
```

Heuristic:

- `persist_count == 0` → drift (pure CPU-reg delta)
- `persist_count <= 1 && same_region` → drift (single-byte VBlank race)
- `persist_count >= 3 || !same_region` → bug
- otherwise → mixed (manual inspection)

For a frame-resolution view of where drift becomes visible, run
`bn6f-track slack ROM FRAMES --input ...` on the orig ROM. Frames
with high `mainline_steps` count (e.g. >50,000) are tight; trampoline
overhead will land there first.

## Why it's hard to fix at the trampoline level

The cycle delta can't be padded away because the trampoline body is
the *minimum* — it needs at least a literal load + branch. Padding
would only make things worse.

The decomp_trampoline_r3safe variant doesn't help because it adds
*more* cycles, not fewer.

Cycle-accurate replacement would mean keeping the original ASM body
inline at the orig address, which defeats the purpose of trampolining
(relocating function body to extension space).

## Fix (verification model)

Don't demand byte-parity per-frame from a partially-trampolined build.
Use these signals instead:

| Signal | What it catches |
|---|---|
| `make verify` (per-call snapshot) | semantic correctness of the C body |
| `per_patch_last_frame.sh` | end-state equality with orig — drift converges by end of bk2 |
| `per_patch_combined_test.sh` | the validated set composes correctly when all enabled together |
| `make verify-strict` with `class=drift` | informational; expected for working patches |
| `make verify-strict` with `class=bug` | real bug — investigate |

The final no-trampoline build (after all functions are in C and the
linker assigns addresses) will be byte-identical to orig with no drift
at all. That's the eventual authoritative parity check.

## Related

- `docs/verification.md#drift-vs-bug-the-trampoline-cycle-overhead-problem`
- `docs/pitfalls/09-lockstep-false-positives.md`
- Memory: [[trampoline_cycle_drift]]
- Memory: [[irq_inventory_bn6f]]
