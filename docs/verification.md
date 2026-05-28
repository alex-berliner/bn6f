# Verification

Audience: anyone reading verify output, adding a new bk2 demo, or
debugging a cache miss.

## Two checks, two levels of strictness

`make verify` (per-call snapshot oracle) — fast iteration. Captures
entry/exit state at every call to every tracked function during the
orig ROM's bk2 playback, then replays each captured call against the
decomp ROM and diffs the exit state. Catches bugs inside the function
body. Misses bugs that *leak past* the function (mode-bit flip
affecting the caller, cycle-timing drift, memory writes between
tracked calls).

`make verify-strict` (lockstep divergence detector) — full-state
parity check. Runs orig + decomp side by side against each bk2's
input, hashes the full visible state (every CPU register including
CPSR, every byte of EWRAM/IWRAM/VRAM/palette/OAM) after each frame,
stops at the first frame where the hashes disagree and reports
which register/region diverged and the PC for each side.

Each RED divergence is auto-classified `class=drift|bug|mixed`:

- **`drift`** — trampoline cycle overhead pushed mainline past a
  VBlank boundary. Heuristic: 0–1 persistent regions differ AND
  both PCs in the same broad region. This is a known limitation
  of partial-trampolining (see "Drift vs. bug" below), not a C-port
  bug.
- **`bug`** — structural problem in the C port. Heuristic: ≥3
  persistent regions differ OR PCs in different regions. Investigate
  by looking at `decomp_pc` and the byte-diff dump above.
- **`mixed`** — 2 persistent regions; manual inspection needed.

The classifier lives in `lockstep()` in `tools/bn6f-track/src/main.rs`
and emits `class=…` plus `pc_delta=…` in the RESULT line for downstream
aggregation.

Workflow: use `make verify` for quick "did my edit break this
specific function" feedback during development. Before claiming a
batch of conversions is correct, run `make verify-strict`. If
verify is green but verify-strict is red with `class=bug`, there's
a cross-call leak — see [debugging.md](debugging.md#harness-blind-spots).
If verify-strict is red with `class=drift`, see below.

## Drift vs. bug: the trampoline cycle-overhead problem

Empirical finding (May 2026): when a function is trampolined to a C
reimplementation, the trampoline itself adds ~6 cycles per call
(standard `decomp_trampoline`) or ~12 cycles (`_r3safe` variant).
That overhead can shift mainline timing enough to expose a race
against the VBlank IRQ — even when the C body is byte-for-byte
instruction-identical to orig.

We proved this with a controlled experiment: rewriting `ByteFill_c`
as `__attribute__((naked))` inline asm matching orig instruction-by-
instruction. Lockstep still RED at coldboot frame 283. Swapping to
`_r3safe` (which preserves r3) shifted divergence to frame 281 but
didn't fix it. The trampoline mechanism alone, with zero C-codegen
difference, produces persistent state divergence.

### Why this happens

The game's only firing IRQ is **VBlank** (verified via `bn6f-track
irqdump` — VCount/GamePak are enabled but never fire during gameplay).
Mainline either reaches `SWI 0x05` / `SWI 0x04` (BIOS IntrWait) in
time and halts cycle-tolerantly, or it doesn't and gets interrupted
mid-work. Trampoline overhead is small (~0.4% of frame budget) but
on tight frames it can tip mainline past the VBlank deadline. When
that happens:

- mainline state at the moment of VBlank differs between orig and
  decomp (one ROM is 1-2 thumb instructions further along)
- the VBlank handler reads in-progress staging buffers (OAM, palette)
  and observes different bytes
- a single-byte EWRAM diff propagates as persistent divergence

### What this means for verification

Per-frame byte-parity against orig is **not achievable** from a
partially-trampolined build. This is a property of the approach, not
a fixable bug. Trampolines are scaffolding for incremental development;
the end state (all functions in C, linked directly, no trampolines)
removes the constraint entirely.

In the interim:

- `make verify` (per-call semantic check) remains the primary
  correctness gate during development.
- `make verify-strict` with `class=drift` failures are expected and
  acceptable for individual patches; treat them as informational.
- `make verify-strict` with `class=bug` failures must be investigated
  — they indicate real C-port issues.
- A future fully-decomp'd build can be lockstep'd against orig with
  no trampolines; that's the authoritative correctness check.

### Future work

The proposed cycle-precise slack profiler (measure orig's headroom
between mainline finishing and VBlank firing, per frame) would let
us predict which frames are drift-sensitive and either skip-trampoline
or inline-replace specific functions. That requires forking and
rebuilding libmgba (instruction-callback hook), so it's deferred.

## Per-call snapshot model

The harness verifies "decomp behaves the same as orig" at the
**per-call** granularity, not per-frame or per-ROM-byte. For each
tracked function it captures the CPU + memory state at every call
boundary during the orig ROM's bk2 playback, then replays each
captured call against the decomp ROM and diffs the exit state.

```
orig ROM ──┐
           ├─► record phase: bk2 playback, snapshot {entry, exit-delta}
bk2 input ─┘                  for every call of every tracked function
                              → tests/fixtures/calls/<bk2>/<fn>/<i>.{entry,exit.delta}.bin

decomp ROM ◄── replay phase: load entry, jump to <fn>, run until exit,
                              diff against orig's exit.delta
```

If any pair's exit state diverges (CPU regs, IWRAM, EWRAM, VRAM,
palette, OAM) the pair fails. All pairs must pass for verify to be
green.

## Phases

`make verify` runs two phases, both inside the `bn6f-track verify-all`
orchestrator:

### Phase A — record

For each bk2 in `tests/fixtures/demos/bk2/`:
1. Load the orig ROM + savestate (if any) + input log.
2. Step through every frame, watching for entries into tracked functions.
3. On entry, save `{registers, IWRAM diff base}` to `entry.bin`.
4. On exit, save the `(reg deltas, memory writes)` since entry to
   `exit.delta.bin` (typically ~26 bytes; an `exit.bin` would be ~290 KB).

Output: `.verify-cache/<bk2_sha>/<fn>/<pair_idx>.{entry,exit.delta}.bin`
plus `callgraph.txt` (transitive callee map for the radius-sha
optimization) and `pair_pass.txt` (last-green radius shas).

Phase A is **cache-keyed on `(orig_rom_sha, bk2_sha)`**: if the orig
ROM and the bk2 haven't changed (the normal case during decomp work),
Phase A is a full cache hit and skips entirely. Steady-state verify
runs do zero record work.

### Phase B — replay

For each cached pair: load `entry.bin` into the decomp ROM, jump to
the function's address, run until it returns, compare the resulting
exit state against `exit.delta.bin`. Parallel across pairs via rayon.

The **incremental cache (Opt D)** skips pairs whose decomp code-radius
hash matches the last green run: for each function compute a sha of
its bytes in the decomp ROM plus every transitive callee's bytes
(from the callgraph). If that radius sha matches the one stored in
`pair_pass.txt`, the function's bytes and every callee's bytes are
unchanged → every captured pair will still pass → skip them. On a
typical edit touching 1–3 functions this prunes ~9670 of 9677 pairs.

## bk2 fixture format

Each demo is a 4-file group under `tests/fixtures/demos/bk2/`:

```
intro.bk2            BizHawk movie (zip: Input Log.txt, savestate, ...)
intro.input          extracted: u16 LE joypad mask + u16 LE pad, per frame (4 bytes/frame)
intro.ss             extracted: raw mGBA savestate (BizHawk-wrapped prefix stripped)
intro.md             generated metadata (frame count, BIOS sha, source bk2)
```

`bk2_extract.py` produces `.input`, `.ss`, and `.md` from the `.bk2`:

```
python3 tools/bk2_extract.py path/to/foo.bk2 --out-prefix tests/fixtures/demos/bk2/foo
python3 tools/bk2_extract.py path/to/foo.bk2 --no-state   # for cold-boot bk2s
```

The `--no-state` flag is for bk2s that start from power-on (no
savestate inside the .bk2). `coldboot.bk2` is the canonical example.

### Adding a new bk2

1. Record a movie in BizHawk's mGBA-Hawk core against the orig retail
   ROM. Use a real GBA BIOS (sha `300C20DF6731A33952DED8C436F7F186D25D3492`).
2. Drop the `.bk2` into `tests/fixtures/demos/bk2/`.
3. Run `bk2_extract.py` to produce `.input`/`.ss`/`.md`.
4. Commit all 4 files. The next `make verify` picks it up.

The bk2 should exercise the functions you're converting. A bk2 that
sits on the title screen for 5 minutes won't catch much.

## Reading verify output

```
=== bn6f-track verify-all ===
orig:   build/bn6f_orig.gba
decomp: build/bn6f_decomp.gba
cache:  .verify-cache
bk2 fleet: 3 demos, 491 target functions
orig sha: 1e8c774b

--- phase A: record ---
[intro] cache hit: 24 fns, 487 pairs
[coldboot] cache hit: 142 fns, 0 pairs
[intro_to_end_tutorial] cache hit: 12 fns, 553 pairs

--- phase B: replay vs decomp ---
[intro] 24/24 pairs (0 failed; 7 fns skipped)
[coldboot] 0/0 pairs (0 failed; 142 fns skipped)
[intro_to_end_tutorial] 41/41 pairs (0 failed; 12 fns skipped)

verify-all: green (3/3 bk2s passed)
```

| Field | Meaning |
|---|---|
| `cache hit: K fns, P pairs` | Phase A skipped entirely; K functions had P pairs recorded previously |
| `K/N pairs` | K passed of N attempted in Phase B |
| `failed` | non-zero means at least one pair's exit state diverged |
| `skipped` | radius-sha unchanged from last green; pairs known still passing |

A failed pair prints the function name, the bk2, and the pair index:

```
[intro/FooBar/3] expected r0=0x1234 got 0x5678
[intro/FooBar/3] expected EWRAM[0x02009a2c]=0x42 got 0x00
```

## Lockstep model (verify-strict)

```
orig ROM ──┐                    ┌─► capture state hash
           ├─► step 1 frame ─►──┤
bk2 input ─┤                    └─► compare ─► differ? stop + report
           ├─► step 1 frame ─►──┐
decomp ROM ┘                    └─► capture state hash
```

The state hash includes the full CPU register file (gprs[0..15] +
cpsr), all of EWRAM (256 KB), IWRAM (32 KB), VRAM (96 KB), palette
RAM (1 KB), and OAM (1 KB). **Nothing visible to game code is
excluded.** If decomp produces a different sequence of writes from
orig — to any register or any RAM byte — the first frame where the
state hashes disagree is the first frame where the regressions
become observable.

`make verify-strict` aggregates the per-bk2 results into a summary
table:

```
[1] coldboot... FAIL (frame 279, decomp PC 0x087FE8D4 = CopyWords_c+0x18)
[2] intro... PASS (6239 frames)
[3] intro_to_end_tutorial... PASS (16441 frames)

=== verify-strict summary ===
FAIL  coldboot               frame 279  0x087FE8D4  CopyWords_c+0x18
PASS  intro                  6239 frames
PASS  intro_to_end_tutorial  16441 frames

FAIL: 1 of 3 bk2s diverged (2 passed)
Full lockstep output in build/verify-strict.log
```

The FAIL row gives the bk2, the divergence frame, the decomp PC at
that frame, and the nearest C symbol (`<fn>_c+0xN`) — the broken
conversion. Per-bk2 detailed output is in `build/verify-strict.log`.

Direct invocation of `bn6f-track lockstep` (without the wrapper)
prints the full per-region diff table:

```
*** DIVERGENCE at frame 279 (1.83s wall) ***
differing components: r0, r1, r2, r3, sp, lr, pc, iwram

  field         orig     decomp
  ------   ---------- ----------
  *r0         2004220          0
  *r1         2004220    20046a0
  *r2             f1c        a9c
  *r3               0    20046a0
   r4               0          0
   ...
  *sp         3007dc8    3007de4
  *lr         8006c4a    87fe8e7
  *pc         80014f6    87fe8d4
   cpsr      2000003f   2000003f

  region     orig sha decomp sha
  ------   ---------- ----------
   ewram     9dfde8c6   9dfde8c6
  *iwram     cc959ffd   28aaafc3
   palette   60cacbf3   60cacbf3
   vram      9f13a523   9f13a523
   oam       60cacbf3   60cacbf3

Frame 279 is the first divergence. Earlier frames matched.
```

The differing PC tells you exactly what code path each side is
executing. In the example above, orig is at `0x080014F6` (an ASM
function in the original ROM), decomp is at `0x087FE8D4` (inside
the `.c_code` section — one of our C functions). That tells you
*which conversion* caused the divergence: it's the C function
containing PC `0x087FE8D4`. Find it with:

```
arm-none-eabi-nm --numeric-sort build/bn6f.elf | grep -B 1 '087fe8d'
```

Then either fix or revert that conversion.

To trace deeper within the failing frame:

```
bn6f-track lockstep --orig ... --decomp ... --input ... --max-frames 279
# then inspect decomp at frame 279 with probe:
bn6f-track probe build/bn6f_decomp.gba 279 --input <input_path>
```

## Why two checks instead of one

Per-call snapshots are O(K) per fn (K calls per fn), parallelize
trivially, and isolate *which* call broke — invaluable during
development. But they only sample at call boundaries.

Lockstep is O(frames × state_size) — slower (~50-100 ms per frame
for ~256 KB of state), but it sees everything. Use per-call as the
fast feedback loop, lockstep as the gate.

The model has blind spots even with lockstep — see
[debugging.md](debugging.md#harness-blind-spots). Notably: cycle-
timing drift can produce identical visible state at every frame
boundary but different intra-frame behavior (e.g., a VRAM write
happening 100 cycles earlier in decomp than orig). If the game
re-reads the VRAM mid-frame it'll see the same data; if a peripheral
samples mid-frame it might not. We don't catch that.
