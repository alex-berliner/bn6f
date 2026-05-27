# bn6f-track

Per-call decomp verification harness, written in Rust against libmgba 0.11.
See [docs/harness.md](../../docs/harness.md) for the architecture overview,
[docs/verification.md](../../docs/verification.md) for the verify model,
and [docs/debugging.md](../../docs/debugging.md) for the decision tree.

## Build

```
cargo build --release --manifest-path tools/bn6f-track/Cargo.toml
```

Binary lands at `tools/bn6f-track/target/release/bn6f-track`. Links
vendored `tools/libmgba/lib/libmgba.so.0.11` via rpath so direct
invocations don't need `LD_LIBRARY_PATH`.

## Subcommand reference

| Subcommand | Purpose |
|---|---|
| [`smoke`](#smoke) | Quick boot check + fps benchmark |
| [`track`](#track) | One-pass tracker (single ROM, hits/calls/callgraph) |
| [`record`](#record) | Phase A of verify: capture entry/exit pairs |
| [`replay`](#replay) | Phase B of verify: replay pairs against another ROM |
| [`verify-all`](#verify-all) | Orchestrator that runs Phase A + Phase B |
| [`probe`](#probe) | Per-instruction trace with invalid-PC trip |
| [`crashwatch`](#crashwatch) | FATAL/ERROR log capture at smoke speed |
| [`framebuf`](#framebuf) | Render frame N as PPM |
| [`bootstate`](#bootstate) | Composite state hash at frame N |
| [`recvideo`](#recvideo) | mp4 encode of N frames |

### smoke

```
bn6f-track smoke ROM [FRAMES]
```

Runs ROM for FRAMES frames (default 60) twice, reports final PC and
fps for each pass. Logger is silenced — catches only `Core::new`
failures (ROM/BIOS missing, libmgba init error). Use for: "is the
build wired up". For correctness use `crashwatch`.

### track

```
bn6f-track track ROM FRAMES SYMBOLS [OUTPUT] [--input PATH]
```

Single-ROM tracker. Reads function-entry symbols from SYMBOLS file
(one `0xADDR NAME` per line — produced by `make function-symbols`),
runs the ROM, counts hits/calls per function, dumps a callgraph.
OUTPUT is the JSON destination (defaults to stdout).

### record

```
bn6f-track record ROM FRAMES SYMBOLS SESSION_DIR [opts] FN_ADDR [FN_ADDR...]
```

Plays ROM through FRAMES with optional --input/--state. On every call
to each tracked function, snapshots {entry CPU state, exit delta}
into `SESSION_DIR/<fn>/<pair_idx>.{entry,exit.delta}.bin`. Used as
Phase A inside `verify-all` against the orig ROM.

Options:
- `--input PATH` — per-frame joypad input (4-byte stride .input file)
- `--state PATH` — savestate to load before playback (cold boot if omitted)
- `--no-dedup` — keep every pair (default: skip pairs identical to
  the first one for a given function)
- `--progress N` — report `i/n frames` every N frames
- `-v / --verbose` — extra diagnostic output

### replay

```
bn6f-track replay ROM SESSION_DIR [-v]
```

Loads pairs from SESSION_DIR (output of `record`), for each pair
loads its entry savestate into ROM, jumps to the function, runs
until return, diffs the exit delta. Reports pass/fail per pair.
Phase B of verify-all.

### verify-all

```
bn6f-track verify-all \
    --orig ROM \
    --decomp ROM \
    --symbols PATH \
    --demos-root DIR \
    --cache-dir DIR \
    [--parallel N] \
    [--record-dir DIR] \
    FN_ADDR [FN_ADDR...]
```

End-to-end verify. Discovers every `.bk2` under `--demos-root/bk2/`,
runs Phase A (cache-hit fast path) against `--orig`, then Phase B
against `--decomp`. `--cache-dir` is the persistent snapshot store.
`--parallel N` = cross-bk2 worker count. `--record-dir DIR` (optional)
also records mp4 of each bk2 against orig + decomp before verifying.

Exit 0 if every pair passes, non-zero on the first failure.

### probe

```
bn6f-track probe ROM FRAMES [--input PATH]
```

Per-instruction trace via mDebugger CALLBACK mode. On any PC outside
the executable regions (ROM 0x08000000-0x09FFFFFF, IWRAM, EWRAM, BIOS)
stops, dumps the last 64 (PC, instr, mode) tuples and full registers.
Slow (~14K instr/s) but precise about where the bad branch came from.

### crashwatch

```
bn6f-track crashwatch ROM FRAMES [--input PATH]
```

Smoke-speed run with capturing logger. Exits 2 on the first FATAL
log. Stops on FATAL but counts ERRORs without aborting. Use for:
"does mGBA log anything bad while running this ROM?"

### framebuf

```
bn6f-track framebuf ROM FRAMES OUT.PPM
```

Renders FRAMES frames with PPU enabled, dumps the final 240×160 RGB
framebuffer as Netpbm PPM. Re-enables frameskip (set to 0 by default
in this subcommand). Pair with `diff -q orig.ppm decomp.ppm` for a
pixel-identical check.

### bootstate

```
bn6f-track bootstate ROM FRAMES [--state PATH]
```

Composite sha1 of `(CPU regs gprs[0..15] + cpsr, EWRAM, IWRAM, palette,
VRAM, OAM)` after FRAMES frames. With `--state PATH` loads a savestate
first. Output per region + composite.

Use to bisect drift: run on orig and decomp at the same FRAMES, the
first FRAMES at which composite_sha diverges is the cycle the two
runs first differ.

### recvideo

```
bn6f-track recvideo ROM FRAMES OUT.mp4 [--input PATH] [--state PATH]
```

Encodes FRAMES frames to mp4 (libx264 CRF 28, AAC 128k). Optional
bk2-extracted input + savestate. ~600 fps including encode.

## Environment

| Var | Effect |
|---|---|
| `BN6F_BIOS` | Path to real GBA BIOS (default `/home/alex/gbabiosworld.bin`); HLE if file missing |
| `BN6F_TRACK_FRAMESKIP` | PPU frameskip (default `i32::MAX` = no rendering; set `0` for video paths) |
| `MGBA_PREFIX` | Override the vendored libmgba prefix |

## Modifying the harness

The Rust source is `src/main.rs` (~2800 LOC), `src/snapshot.rs`
(BNSS/BNDL formats), `src/cache.rs`. The `mgba_sys` bindings are
generated by `build.rs` from `wrapper.h`. If you change `wrapper.h`,
`cargo build` regenerates `target/.../mgba_sys.rs`.

See [docs/harness.md](../../docs/harness.md) for the architecture
explanation including the per-instruction callback, EntryBitset,
and snapshot format.
