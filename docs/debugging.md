# Debugging

Audience: you ran something and it's broken. Find the right tool.

## Decision tree

```
Symptom                                  → Tool
─────────────────────────────────────────────────────────────────
ANY suspect patch                        → make verify-strict
                                           (authoritative correctness;
                                           catches what make verify misses)

make verify-strict fails                 → divergence report names the
                                           frame + PC + region. Decomp's
                                           PC inside .c_code tells you
                                           which C function caused it.
                                           See lockstep below.

make verify fails (per-call)             → look at pair index, run
                                           bn6f-track verify-all
                                           with one address (per fn).
                                           ALSO run verify-strict before
                                           assuming the fix is done.

make verify GREEN but verify-strict RED  → cross-call leak — mode flip,
                                           untracked caller corruption,
                                           etc. See "Harness blind spots".

make decompile fails (linker error)      → docs/build.md: trampoline
                                           PAD wrong, or function table
                                           reference dropped

ROM crashes in interactive mGBA          → crashwatch
("Jumped to invalid address" or similar)

ROM "hangs" but no crash log             → make verify-strict FIRST.
(stuck on splash, screen frozen)           Then bootstate at frame N
                                         → recvideo for visual diff
                                         → make videos for full bk2 pair

Screen blank / wrong sprites             → make verify-strict
                                         → framebuf orig vs decomp
                                         → bisect with tools/bisect_visual.sh

C compiler emits weird code              → arm-none-eabi-objdump
                                           build/c/<file>.o; compare to
                                           what the orig ASM does
```

## Tool reference

### `bn6f-track lockstep --orig ROM --decomp ROM --input PATH [--state PATH] [--max-frames N]`

The authoritative correctness check. Runs both ROMs side by side
against the same bk2 inputs, snapshots full visible state (CPU regs
+ all RAM regions) after each frame, stops at the first divergent
frame. Reports:

- Which frame diverged
- Which CPU registers and/or memory regions differ
- Each side's PC, SP, LR, CPSR
- Per-region sha1 (so you can localize: EWRAM diff = data state,
  IWRAM diff = scratch + sound, VRAM diff = graphics, etc.)

**This is the gate.** Per-call verify (`make verify`) can pass while
lockstep fails — that means the patch corrupts state outside its
own snapshot window. Always run lockstep before claiming a batch of
conversions is correct.

Usage in the make target: `make verify-strict` runs lockstep on all
bk2s sequentially. Exit non-zero on the first failure.

### `bn6f-track crashwatch ROM FRAMES [--input PATH]`

Runs the ROM at smoke speed (~700 fps) with libmgba's logger
**capturing** instead of silenced. Exits with code 2 on the first
FATAL log. ERROR-level logs are counted but don't abort. Output
includes the message text and the frame at which it fired.

Use for: "does this ROM crash inside mGBA?" Catches `Jumped to
invalid address`, `Stub opcode`, invalid SVC, etc.

### `bn6f-track probe ROM FRAMES [--input PATH]`

Per-instruction trace with invalid-PC detection. Maintains a 64-entry
ring buffer of recent (PC, instr_word, thumb-or-arm) tuples. On the
first PC outside any executable region (ROM / IWRAM / EWRAM / BIOS)
it stops, dumps the ring buffer and full CPU register state, exits
non-zero.

Use for: "where exactly did the bad branch come from?" Slower than
crashwatch (~14K instr/s) but tells you the call site, not just that
something crashed.

### `bn6f-track framebuf ROM FRAMES OUT.PPM`

Renders the ROM with PPU enabled for FRAMES frames, dumps the final
240×160 RGB framebuffer as a Netpbm PPM. Use `convert` or `feh` to
view, or `diff -q` against an orig framebuf for a binary
pixel-identical check.

Use for: "what does the user actually see at frame N?" Pixel-identical
to orig = visually OK. `uniq -c` = quick spot check (1 unique byte
= blank screen).

### `bn6f-track bootstate ROM FRAMES [--state PATH]`

Composite sha1 of CPU registers + EWRAM + IWRAM + VRAM + palette + OAM
at the end of FRAMES frames. With `--state PATH` loads a savestate first.

Run on orig and decomp side-by-side: matching composite_sha = bit-exact
state. Diverging = look at the per-region shas to localize.

Use for: "did the ROM drift?" Catches state divergence the framebuf
might hide (sprites in wrong slots that happen to overlap visually).

### `bn6f-track recvideo ROM FRAMES OUT.mp4 [--input PATH] [--state PATH]`

Plays the ROM for FRAMES frames (optional bk2-extracted input + savestate)
and encodes to mp4 (libx264 CRF 28 + AAC). Use to:
- See the actual playthrough
- Send to someone for visual review
- Diff orig vs decomp behavior over time

### `make videos`

Wrapper around `recvideo` for the full bk2 fleet × {orig, decomp,
nopatch}. Produces `build/videos/<bk2_stem>__{orig,decomp,nopatch}.mp4`.
The `nopatch` flavor (decomp build with empty manifest) is the
control case — if `nopatch` differs from `orig` the regression is in
the build infrastructure, not the manifest.

### `tools/bisect_visual.sh N`

Builds decomp with the first N manifest entries, renders frame 600,
exits 0 if graphics rendered (uniq > 5) or 1 if blank. Use binary
search over N to find the manifest entry that broke graphics.

Restores the manifest on exit (`trap`-protected). Doesn't survive
multi-cause regressions natively — for those see
[multi-cause bisect](#multi-cause-bisect).

### `tools/mgba-headless`

True standalone mGBA 0.11 CLI (not the harness's libmgba binding).
Use to cross-check that a divergence isn't a harness-specific issue.
`-l 127` dumps every SWI, DMA, I/O register write to stdout. Useful
for diffing the two ROMs at the libmgba event level.

## Harness blind spots

The per-call verify oracle (`make verify`) misses:

1. **LR-bit-bx mode flip in untracked callers.** The callee's exit
   state matches orig (CPSR T=1 at return instruction). The flip
   happens at the BX in the C epilogue, affecting only the caller —
   which isn't snapshotted. Symptom: verify green, ROM crashes
   interactively. Mitigation: grep `.word <fn>+1` before adding to
   manifest (see decomp-workflow.md).

2. **Cycle-timing drift.** C software loops take different cycle
   counts than the BIOS SWI versions they replace. Per-call snapshots
   compare exit state, not cycle counts. The drift accumulates and
   eventually shifts when vblank/timer IRQs fire. Symptom: verify
   green, decomp visibly behind orig in `make videos`. Mostly benign
   (game just runs slightly different timing) but can cascade if a
   game routine assumes IRQ-relative-to-game-state.

3. **VRAM/OAM writes that happen entirely outside tracked functions.**
   Snapshots cover IWRAM + EWRAM + VRAM + palette + OAM around tracked
   call boundaries. State written between tracked calls (e.g., by an
   IRQ handler) is captured at the next entry, but if no tracked
   function fires after a bad write the divergence sits silent until
   the bk2 ends. Mitigation: add a tracked function on the boot path
   that runs every frame (e.g., `main_awaitFrame`).

4. **Banked SVC/IRQ stack writes.** The top 256 bytes of IWRAM are
   excluded from snapshots (see harness.md). C SWI reimpls don't touch
   that region. Doesn't matter for typical game code, but if a routine
   reads from `0x03007F00+` after a BIOS call expecting transient
   data, our verify won't notice.

## Multi-cause bisect

`tools/bisect_visual.sh` does single-cause prefix bisect. When you
suspect multiple manifest entries each contribute, the iterative
pattern is:

1. Bisect the prefix → find first bad entry X.
2. Add X to a "known bad" list.
3. Re-bisect the same range with X excluded → find next bad entry Y.
4. Repeat until the full manifest minus known-bads is green.

See the bisect session for the LR-bit-bx 17-instance batch — that
used this pattern.

## When the harness itself is suspect

- **No FATAL log appearing where you'd expect one** → check that
  `install_capturing_logger()` ran (smoke calls `silence_libmgba_logger()`
  which is sticky until overridden).
- **Cargo build fails after libmgba rebuild** → libmgba ABI shifted;
  rerun `build.rs` (touch `wrapper.h` to force regen). Check that
  the cmake `USE_*` defines match `build.rs`'s `clang_arg`.
- **Snapshots have wrong size** → run `make clean && make verify` to
  force a full re-record; the cache might be from an older snapshot
  format version.

## Logs and reports

`make verify` writes `verify-all` output to stderr; capture with
`make verify 2>&1 | tee /tmp/verify.log`. The per-pair diff lines
look like `[bk2/fn/pair] expected ... got ...` — grep that prefix to
find specific failures.

For the harness's own behavior, `tools/bn6f-track/target/release/bn6f-track`
without arguments prints the help reference with all subcommands.
