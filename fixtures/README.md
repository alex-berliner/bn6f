# Pilot input fixtures

Each `*.inputs` file is a **self-contained recording**: a keypad script
replayed from cold boot against `build/bn6f.gba` + the real BIOS. Because the
core is deterministic (harness B1), the script *is* the recording — no
savestate to ship, and every replay reproduces the same machine state
bit-for-bit (verified: replaying a fixture twice yields an identical
full-state hash).

These were recorded by driving the game through the harness and watching the
output as PNG screenshots — no human controller, no BizHawk. BizHawk `.bk2`
import stays on the roadmap for human-recorded runs; these cover the same
Phase-1 need (deterministic real-BIOS traces) today.

## Format

One directive per line; `#` starts a comment.

    hold <frame> <KEYS|->   set the held keypad state from this frame on
    tap  <frame> <KEYS>     press KEYS for 2 frames, then release to the hold
    end  <frame>            total frames to run (required)

`KEYS` is `+`-joined from `A B START SELECT UP DOWN LEFT RIGHT L R`; `-` means
no keys. Frames are non-decreasing.

## Replay

    cargo run --release --bin pilot -- --script fixtures/01_boot_to_bedroom.inputs \
        [--png out.png] [--png-every N:dir] [--save-state s.bin]

BIOS is found via `$BN6F_BIOS` (or a documented fallback); the never-HLE gate
applies. `--png-every N:dir` dumps a frame every N for reviewing a run.

## Fixtures

| File | Reaches | Subsystems exercised |
|------|---------|----------------------|
| `01_boot_to_bedroom.inputs` | player control in Lan's bedroom | BIOS boot, title, save-select, the full opening cutscene chain, overworld load |
| `02_boot_to_livingroom.inputs` | downstairs living room | above + overworld walking and a room/map transition |

These are seed fixtures proving the recorder end to end. Deeper runs (net
jack-in, a virus battle — the hot path) are more of the same navigation and
will be added as the coverage harvester (Phase 1) makes clear which areas the
corpus still lacks.

---
_Last updated: 2026-07-12 13:34:42 -0400_
