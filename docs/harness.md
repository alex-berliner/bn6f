# Harness architecture

Audience: anyone modifying `tools/bn6f-track/`, debugging harness
behavior, or wondering how a snapshot maps to a libmgba call.

## Layout

```
tools/bn6f-track/
  Cargo.toml             release profile, opt-level 3 + lto thin
  build.rs               bindgen against vendored libmgba 0.11
  wrapper.h              bindgen entry: which libmgba headers to expose
  src/
    main.rs              everything except snapshot + cache
    snapshot.rs          BNSS (entry) + BNDL (exit delta) formats
    cache.rs             per-bk2 cache layout + sha helpers
```

The harness is a single Rust binary that links libmgba 0.11 (vendored
under `tools/libmgba/`). No subprocesses, no IPC — everything lives in
one process. The shared `Core` wrapper boxes a `*mut mCore` and exposes
methods for stepping, register access, raw memory reads, savestate
load, video encoder attach.

## libmgba bindings

`build.rs` runs bindgen against `wrapper.h`:

```c
#include <mgba/core/core.h>
#include <mgba/core/config.h>
#include <mgba/core/interface.h>
#include <mgba/core/log.h>
#include <mgba/core/serialize.h>
#include <mgba/debugger/debugger.h>
#include <mgba-util/vfs.h>
#include <feature/ffmpeg/ffmpeg-encoder.h>
```

The build flags must match how the vendored libmgba was compiled — a
mismatch silently shifts struct field offsets and breaks every
function-pointer call through `mCore`. The current set:

```
-DENABLE_VFS=1
-DENABLE_DIRECTORIES=1
-DM_CORE_GBA=1
-DCOLOR_16_BIT=1
-DCOLOR_5_6_5=1
```

If a libmgba rebuild changes cmake options, `build.rs` needs the same
flags. The bindgen allowlist keeps the generated `mgba_sys.rs` small
(only `mCore.*`, `mLog.*`, `mDebugger.*`, `VFile.*`, `FFmpegEncoder.*`).

## Core wrapper

```rust
struct Core {
    raw: *mut mgba_sys::mCore,
    _video_buf: Vec<u8>,              // 256*160*4 u8, mCore.setVideoBuffer dest
    debugger: Option<Box<mDebugger>>,  // Some when attach_*_debugger() ran
    dbg_module: Option<Box<mDebuggerModule>>,
}
```

`Core::new(rom)`:
1. `mCoreFind` → `mCore.init`
2. `setVideoBuffer` (allocates the 256x160 u32 buffer)
3. `mCoreLoadFile` (the ROM)
4. `mCoreConfigInit` + frameskip override (default `i32::MAX` =
   PPU drawing disabled, set `BN6F_TRACK_FRAMESKIP=0` to enable)
5. Auto-load real BIOS from `/home/alex/gbabiosworld.bin` if present
6. `mCore.reset()`

The frameskip override is **critical** — without it `recvideo` and
`framebuf` get blank images because the PPU never finishes a frame.
Subcommands that need video set frameskip back to 0 via
`reloadConfigOption` after construction.

## Per-instruction callback (Opt 3)

The verification path uses `mDebugger` in CALLBACK mode with a custom
module:

```rust
unsafe extern "C" fn custom_cb(module: *mut mgba_sys::mDebuggerModule) {
    // read PC + CPSR directly from ARMCore.gprs[15] / .cpsr.packed
    // (avoiding readRegister name-dispatch + fn pointer indirection)
    let pc = ...;
    let cpsr = ...;
    let true_pc = pc - if thumb { 2 } else { 4 };

    if ENTRIES.contains(true_pc) {
        // record entry, push to PENDING stack
    }
    // ... exit detection via PENDING top match ...
}
```

`ENTRIES` is a bitset (one bit per 2-byte instruction in the entire
ROM region, see `EntryBitset` in main.rs) — an O(1) `contains` test
that replaced a HashSet probe. With ~13K tracked entries the HashSet
saturated libmgba's internal bloom filter and dragged the per-frame
rate down to 0.4 fps; the bitset gets us back to native speed.

## Subcommands

See `tools/bn6f-track/README.md` for the user-facing reference. The
internal dispatch in `main.rs:main`:

```
smoke          smoke_test()              ~20 LOC
track          track()                   record-style debug, single ROM
record         record()                  Phase A path used by verify-all
replay         replay()                  Phase B path used by verify-all
verify-all     verify_all()              orchestrator
probe          probe_cold_boot()         per-instr trace + invalid-PC trip
crashwatch     crashwatch()              FATAL/ERROR log capture
framebuf       framebuf()                PPM dump of frame N
bootstate      bootstate()               composite hash at frame N
recvideo       recvideo()                mp4 encode of N frames
```

## Snapshot format

See `snapshot.rs` for the wire format. Two files per call pair:

- **`<i>.entry.bin`** — BNSS magic + zstd-compressed mGBA core state
  (one full savestate, ~290 KB compressed, ~1 MB raw). Loaded into
  the decomp Core to start the replay at the exact point the orig
  was about to enter the function.

- **`<i>.exit.delta.bin`** — BNDL magic + register delta + `(addr, byte)`
  list of memory writes since entry. Typically 20-200 bytes. The
  delta is symmetric: both orig→entry-to-exit and decomp's same span
  must produce the same set of writes; missing or extra ones fail.

Snapshots skip the top 256 bytes of IWRAM (`0x03007F00-0x03007FFF`).
That region holds the ARM SVC/IRQ banked stacks, written transparently
by BIOS SWI handlers. C reimpls of SWI wrappers don't go through SVC
mode, so this region naturally diverges without affecting visible
behavior.

## Cache layout

```
.verify-cache/
  <bk2_stem>/
    callgraph.txt           transitive callee map: <fn> -> [<callee>, ...]
    pair_pass.txt           last-green radius sha per fn: <fn> -> <sha>
    <fn_name>/
      0000.entry.bin
      0000.exit.delta.bin
      0001.entry.bin
      0001.exit.delta.bin
      ...
      .recorded             marker file: Phase A populated this dir
```

The cache key is `(orig_rom_sha, bk2_sha)`; the actual directory uses
a stable `<bk2_stem>` name and stores the key inside. `cache.rs` has
the read/write helpers.

## Video encoder hook

`Core::start_recording(path)` boxes an `FFmpegEncoder`, calls
`mCoreSetAVStream(core, &enc.d)`, and returns the box. Each subsequent
`runFrame` pushes a frame into the encoder. `Core::stop_recording(enc)`
clears the AVStream and closes the encoder (writes mp4 trailer).

The encoder is configured at CRF 28 (libx264) and 128k AAC; samples
land at 32768 Hz mono (the m4a engine's output rate). Frame rate
defaults to GBA's 59.73 Hz from `FFmpegEncoderInit`'s GBA preset.

## Performance landmarks

| Path | Speed | Bottleneck |
|---|---|---|
| `smoke` | 600-1300 fps | nothing — pure mCore.runFrame |
| `crashwatch` | 600-700 fps | capturing logger + per-frame log check |
| `framebuf` | 600-700 fps | PPU rendering enabled |
| `recvideo` | ~600 fps | encoder + PPU |
| `probe` | ~14K instr/s | per-instruction Rust cb + thread-local |
| `verify-all` (cache hit) | <5s for ~10K pairs | rayon-parallelized replay |
| `verify-all` (full record) | ~30s per bk2 | Phase A pump |

`probe` is intentionally slow — the tradeoff is precise invalid-PC
detection with a 64-entry recent-PC ring buffer. For "is this ROM
broken" use `crashwatch` first.
