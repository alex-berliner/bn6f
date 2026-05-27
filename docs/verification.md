# Verification

Audience: anyone reading verify output, adding a new bk2 demo, or
debugging a cache miss.

## Model

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

## Why this model

Per-call snapshots catch issues the harness's other signals miss
(framebuf only sees screen, bootstate only checks at one frame), and
they isolate which specific call diverged — invaluable for narrowing
down a bug. They also let `make verify` parallelize across `(bk2,
function, pair)` tuples.

The model has blind spots — see [debugging.md](debugging.md#harness-blind-spots).
Notably: a function whose internal mode-flip corrupts an untracked
caller will pass per-call verification but produce a broken ROM at
runtime. The video recording and bootstate diff catch those.
