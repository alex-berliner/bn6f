# Build

Audience: anyone who needs to build the ROM, run the harness, or
understand where artifacts go.

## Toolchain

All toolchain binaries are vendored under `tools/`. Nothing should be
installed system-wide except a working `gcc`, `make`, `git`, and Python 3.

```
tools/
  agbcc/             agbcc compiler + libgcc.a (gcc 2.95-derived; built
                     by tools/agbcc-src via `make setup-toolchain`)
  binutils/          arm-none-eabi-{as,ld,objcopy,objdump} (vendored
                     2.42 build)
  gbagfx/            asset converter for sprites/tiles (built by
                     `make setup-toolchain`)
  libmgba/           libmgba 0.11 prebuilt with USE_FFMPEG=ON. Used by
                     the verification harness and recvideo target.
  bn6f-track/        Rust verification harness (cargo workspace)
```

One-time install: `make setup-toolchain`. Idempotent. Sub-builds
no-op when artifacts already exist.

For why agbcc specifically — see `issues/concerns/01-calling-convention-abi.md`.
Short version: it's the only compiler whose AAPCS variant matches the
ABI the orig binary was compiled against.

## Build flavors

```
make all                Pure ASM build → build/bn6f.gba (sha-matched)
make decompile          ASM + C overlay → build/bn6f.gba (NOT sha-matched)
make orig               Orig-flavor ELF only → build/bn6f_orig.elf
make assets             Build/refresh data/textscript/compressed/*.s.lz
make clean              Remove all build/*.{o,elf,map,gba,sym,dump}
make setup-toolchain    Build vendored tools (one-time, idempotent)
```

`make all` and `make decompile` share `$(ELF)` → `$(ROM)` rule paths,
so they overwrite each other. The `verify` target deduplicates by
copying outputs to `build/bn6f_orig.gba` and `build/bn6f_decomp.gba`.

## What controls the two flavors

The decomp build uses a different linker script and a per-symbol
defsym flag for every entry in `tools/decomp_manifest.txt`:

```
tools/decomp_manifest.txt          # one ASM symbol per line
build/decomp_flags.txt             # generated:
                                   #   --defsym DECOMP_<sym>=1
                                   #   --defsym DECOMP_<sym>=1
                                   #   ...
ld_script.ld                       # 8 MB rom_region, used by `make all`
ld_script_decompile.ld             # 16 MB rom_region with .c_code
                                   # section, used by `make decompile`
```

Each ASM function whose symbol is in the manifest is gated:

```asm
.ifndef DECOMP_FooBar
    thumb_func_start FooBar
FooBar:
    < original body >
    thumb_func_end FooBar
.else
    thumb_func_start FooBar
FooBar:
    decomp_trampoline FooBar_c, <pad>
    thumb_func_end FooBar
.endif
```

`make all` defines no `DECOMP_*` syms, so the .ifndef branch always
expands → matches retail SHA. `make decompile` defines all of them,
the .else branch fires, the body becomes an 8-byte `ldr+bx` trampoline
into the C reimplementation in `build/c/`.

## Verification targets

```
make verify                Build both ROMs, run per-call snapshot oracle
                           against every bk2 in tests/fixtures/demos
make videos                Render mp4 of each bk2 played against
                           orig, decomp, and decomp-with-empty-manifest
                           → build/videos/<stem>__{orig,decomp,nopatch}.mp4
make smoke                 Quick "does decomp boot" smoke (harness smoke
                           subcommand)
```

Override env vars:

| Var | Default | Purpose |
|---|---|---|
| `VERIFY_PARALLEL` | `$(nproc)` | Cross-bk2 worker count |
| `VERIFY_CACHE_DIR` | `.verify-cache` | Per-bk2 snapshot cache |
| `VIDEO_DIR` | `build/videos` | `make videos` output dir |
| `BN6F_BIOS` | `/home/alex/gbabiosworld.bin` | Real GBA BIOS path used by harness Core (HLE if absent) |
| `BN6F_TRACK_FRAMESKIP` | `i32::MAX` | Frameskip during harness runs (no rendering); `0` enables PPU |

## Artifact layout

Everything build-related lands under `build/`:

```
build/
  bn6f.elf                     last-built ELF (orig or decomp, depending)
  bn6f.gba                     last-built ROM
  bn6f.map                     last-built link map
  bn6f_orig.gba                stable copy from `make all`
  bn6f_decomp.gba              stable copy from `make decompile`
  bn6f_decomp_nopatch.gba      empty-manifest decomp (used by `make videos`)
  rom.o data.o ewram.o iwram.o vram.o   .o files for each top-level .s
  c/                           per-C-function .i/.s/.o intermediates
  c_ofiles.txt                 generated: list of build/c/*.o for ld @-file
  decomp_flags.txt             generated: --defsym DECOMP_* lines
  videos/                      `make videos` outputs (if invoked)
```

Root stays clean: only `bn6f.sha1` (tracked) lives there. If you find
a stray `rom.o` or `bn6f.elf` at the repo root, an old Makefile rule
or script slipped in — please file an issue.

## Toolchain quirks

- **agbcc has no `--gc-sections` linker support.** All C functions in
  `src/c/*.c` get linked into `.c_code` regardless of whether they're
  referenced. Unused entries cost ROM space but won't break the build.
- **`binutils/bin/arm-none-eabi-ld`** is a symlink to `arm-none-eabi-ld.bfd`.
  After cloning, if you see "broken symbolic link", run
  `(cd tools/binutils/bin && ln -sf arm-none-eabi-ld.bfd arm-none-eabi-ld)`.
- **`tools/libmgba/lib/libmgba.so.0.11.0`** is committed pre-built.
  Rebuild from `/tmp/mgba-build/mgba` (cmake source) with
  `cmake -DUSE_FFMPEG=ON -DBUILD_HEADLESS=ON . && make mgba && make install`
  if the binding generation (`cargo build`) fails on missing symbols.
