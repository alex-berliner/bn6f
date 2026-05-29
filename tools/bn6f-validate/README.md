# bn6f-validate

Per-frame pixel-hash + video-render validator for the BN6F decomp.
Replaces the old `bn6f-track` harness; built clean to address the
encoder-non-determinism and recvideo/framebuf-mismatch issues that
made the previous mp4-based comparisons unreliable.

## What it does

For each patch in the manifest, builds a per-patch ROM, runs it
through each bk2 fixture, and hashes the visible 240×160 framebuffer
RGB pixels per frame via SHA256. Comparing two hash streams gives
an exact byte-equal pixel check that's:

- **deterministic** — the same emulator state always produces the
  same hash (verified)
- **encoder-free** — no libx264 to introduce false positives
- **fast to compare** — line-by-line text diff

mp4 videos are an optional side-output for human review (libx264
CRF 28). They're for visual spot-check only; the hashes are the
correctness signal.

## Subcommands

```
bn6f-validate hash    ROM --input PATH [--state PATH] [--frames N] --out PATH
bn6f-validate video   ROM --input PATH [--state PATH] [--frames N] --out PATH
bn6f-validate both    ROM --input PATH [--state PATH] [--frames N] --hashes PATH --video PATH
bn6f-validate compare ORIG.txt PATCHED.txt
bn6f-validate run     [--start N] [--end N] [--patch NAME]... [-j N] [--videos] [--no-build]
```

- **hash** — single-ROM single-bk2 hashing pass. Emits a text file
  with one `<frame_index> <sha256_hex>` line per frame.
- **video** — single mp4 render (libx264 CRF 28 .mp4).
- **both** — single emulation pass producing hash file + mp4.
- **compare** — line-by-line diff of two hash files. Exit 0 if
  identical, 1 if differ. Prints `RESULT: pass frames=N` or
  `RESULT: fail frames=N first_diff=F diff_count=D`.
- **run** — orchestrator. Phase 1 builds orig ROM. Phase 2 builds
  one ROM per selected patch (sequential — manifest is shared).
  Phase 3 hashes every (ROM × bk2) in parallel with `-j` workers.
  Phase 4 compares each (patch × bk2) hash against orig in parallel.
  Writes `build/validate_results.csv`.

## Quick usage

```sh
# Build once
(cd tools/bn6f-validate && cargo build --release)

# Validate first 15 patches with 8 parallel hash workers
./tools/bn6f-validate/target/release/bn6f-validate run --end 15 -j 8

# Validate one specific patch + render mp4 for review
./tools/bn6f-validate/target/release/bn6f-validate run --patch ByteFill --videos

# Reuse already-built ROMs (skip phase 1+2)
./tools/bn6f-validate/target/release/bn6f-validate run --no-build -j 8
```

## Outputs

- `build/roms/bn6f_orig.gba` — pure-ASM orig
- `build/roms/bn6f_<NNNNNNN>_<name>.gba` — per-patch decomp
- `build/hashes/orig__<bk2>.txt` — orig per-frame hashes
- `build/hashes/<NNNNNNN>_<name>__<bk2>.txt` — patched hashes
- `build/videos/<rom_stem>__<bk2>.mp4` — optional review mp4
- `build/validate_results.csv` — `rom_stem,bk2,verdict,first_diff_frame`

## How it differs from the old bn6f-track

Old `bn6f-track` had:
- A per-call snapshot oracle (`make verify`)
- A per-frame full-state lockstep (`make verify-strict`) with a
  drift-vs-bug classifier
- A trace tool, slack profiler, IRQ inventory, etc.

That harness ran into:
- Per-frame strict lockstep gave false-positive drift failures on
  patches that were actually correct (trampoline cycle drift)
- mp4 byte-compare was unreliable (libx264 non-deterministic)
- recvideo and framebuf produced different pixels for the same
  emulator state — open bug

`bn6f-validate` is much narrower in scope: just "did the patched
ROM produce the same pixels as orig, at every frame, on every bk2."
That's the only correctness signal that matters and it doesn't
trip on the cycle-drift edge case (drift converges by end of the
single-frame, and per-frame hashes catch sustained divergence
unambiguously when it happens).

## Implementation notes

- libmgba 0.11 is linked from `tools/libmgba/`. mColor is u32 (no
  COLOR_16_BIT define).
- BizHawk .ss files have a 4-byte length-prefix header before the
  inner mGBA savestate; detected via mGBA magic pattern
  (`0x010000XX` little-endian).
- Each `run` worker is a subprocess so any global libmgba state is
  per-process. Parallelism is bounded by `-j`.
- The orchestrator restores `tools/decomp_manifest.txt` via
  `git checkout` between builds so a Ctrl-C leaves the manifest
  in its committed state.
