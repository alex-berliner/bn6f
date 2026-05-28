# MegaMan Battle Network 6: Cybeast Falzar

A disassembly + in-progress C decompilation of Mega Man Battle Network 6
Falzar. Two build flavors live in the same source tree:

* **`make all`** — pure assembly build that produces a ROM bit-identical
  to the retail cartridge (`build/bn6f.gba`, sha1 `0676ecd4...`).
* **`make decompile`** — same source plus the C functions listed in
  `tools/decomp_manifest.txt`. Each manifest entry trampolines its ASM
  function into a C reimplementation. Output: `build/bn6f.gba`. Does
  not match the retail sha (extra `.c_code` section).

Every C conversion is verified against the orig ROM by the harness
under `tools/bn6f-track/`. Two checks: `make verify` (per-call
entry/exit snapshot replay — fast, semantic correctness) and
`make verify-strict` (full-state per-frame lockstep — divergences
auto-classified as `drift` vs `bug`). See
[docs/verification.md](docs/verification.md) for the trampoline-
cycle-overhead caveat that produces unavoidable `drift`-class
failures during incremental development.

## Quick start

```
git clone --recurse-submodules <repo>
cd bn6f
make setup-toolchain       # one-time: agbcc + binutils + gbagfx
make assets                # one-time: build compressed text/script lz files
make all                   # → build/bn6f.gba, checks sha1
make decompile             # → build/bn6f.gba with manifest applied
make verify                # → runs the per-function snapshot oracle
```

If you skip `make setup-toolchain` (already have the toolchain), the
build still expects `tools/agbcc/bin/agbcc` and
`tools/binutils/bin/arm-none-eabi-{as,ld,objcopy,objdump}` to exist
under the repo. `tools/libmgba/` is vendored — the harness links it.

## Documentation

| Doc | When to read |
|---|---|
| [docs/build.md](docs/build.md) | toolchain layout, make targets, where artifacts land |
| [docs/decomp-workflow.md](docs/decomp-workflow.md) | how to convert an ASM function to C without breaking the verify |
| [docs/verification.md](docs/verification.md) | how the per-call snapshot oracle works, bk2 fixtures |
| [docs/harness.md](docs/harness.md) | `bn6f-track` (Rust + libmgba) architecture |
| [docs/debugging.md](docs/debugging.md) | "ROM crashes / screen blank / silently drifts" decision tree |
| [tools/bn6f-track/README.md](tools/bn6f-track/README.md) | harness CLI reference |
| [src/c/README.md](src/c/README.md) | C conventions, wrapper macros |
| [issues/](issues/) | open blockers + concerns catalog |

The pure-disassembly contribution path (matching-ROM symbol/labelling
work) is still at [CONTRIBUTE.md](CONTRIBUTE.md). For the C-decomp side
use [docs/decomp-workflow.md](docs/decomp-workflow.md).

## Layout

```
asm/                 disassembled ASM sources (rom.o aggregates these)
data/                disassembled data + compressed text/script archives
src/c/               C reimplementations (one .c per converted function)
include/             shared inc files, struct headers
constants/           constant definitions
tools/
  agbcc/             agbcc + libgcc (toolchain)
  binutils/          arm-none-eabi binutils
  libmgba/           vendored libmgba 0.11 (USE_FFMPEG=ON)
  bn6f-track/        Rust verification harness
  decomp_manifest.txt   list of ASM symbols converted to C
  function_symbols.txt  generated: orig-ROM function addresses
build/               all build artifacts land here
tests/fixtures/
  demos/bk2/         BizHawk movie files + extracted inputs/savestates
  calls/             per-bk2 captured entry/exit snapshots
issues/              open blockers, concerns, project outlines
docs/                full documentation set
```

## See also

- Discord: [**pret**][Discord]
- [gh LanHikari22/bn6f-modding](https://github.com/LanHikari22/bn6f-modding)

[Discord]: https://discord.gg/vdTW48Q
