# Origin classification — compiled vs hand-written (analysis)

Side investigation out of the Feature 11 (agbcc/ABI) discussion: *how much
of the ROM is compiler-generated C vs hand-written ASM?* Matters because
compiled code is **recoverable** (some C round-trips to the exact bytes)
while hand ASM can only be **reimplemented** (no original C exists) — a
different, smaller job, and where the wrapper/drift hazards concentrate.

## Result (heuristic, by instruction line / function)

```
bucket        funcs    pct      lines    pct
GENERATED     12676  96.1%     375651  93.5%
UNCERTAIN       490   3.7%      22454   5.6%
HAND             20   0.2%       3840   1.0%
```

The hand/system slice is small and **localized**, not smeared:
- `start.s` (boot), `libs.s` (runtime/glue — where the red HAND
  concentrates), `asm38.s` (the ARM IRQ dispatcher, RAM-resident).
- a thin uncertain haze in the earliest engine files (`sprite.s`,
  `main.s`, `asm00_0`, `asm01`).
- the entire numbered bulk (asm21–asm37, object, chatbox, npc, …) is
  0–2% non-generated = essentially pure compiler output.

Chart: `build/origin_map.png` (address-space map + per-file bars), from
`tools/origin_chart.py`.

## Why a clean classifier is hard here (calibration notes)

The signals that flag hand-code in a normal codebase are baked into
agbcc's *normal* output for this game, so they don't discriminate and are
deliberately excluded:
- `mov lr,pc; bx rN` (1882) and `bx rN` (2206) — agbcc's interworking
  call idiom, everywhere.
- r8 / r9 / r10 usage — agbcc freely uses high registers, and the game
  holds ambient globals there (r10 = Toolkit ptr, r5 = sprite/chatbox).
  Confirmed: textbook-compiled functions use r8/r9 as scratch.
- `svc N` (e.g. `svc 6` = BIOS divide) — a BIOS call, appears in ordinary
  code, not a hand signal.

Signals kept (genuinely rare): ARM mode, `mrs/msr`, coprocessor ops, ARM
block-transfer (`stmfd`…), frame-pointer (`fp`/`r11`), computed
`mov pc,rN` jumps.

## Honest caveats

- **HAND 0.2% is a lower bound, not the true hand-written total.** It means
  "confidently hand/system." Hand code that followed compiler-like
  conventions is invisible to static signals and sits in
  GENERATED/UNCERTAIN. The only definitive discriminator is the round-trip
  (does plausible C reproduce the bytes).
- **UNCERTAIN ≠ hand.** It's low-signal: small leaf functions without a
  push/pop frame. A `mov pc, lr` return-style blind spot initially inflated
  it from 3.7% to ~10%; fixed by treating `mov pc, lr` as a recognized
  return. `start.s`/`libs.s` show as amber (uncertain) but are almost
  certainly hand-written — uncertainty hiding real hand-code.

## So what (for the project)

Very little code is in the "reimplement, can't byte-match" bucket, and it's
localized to boot + runtime + IRQ. Good news for the full-C end goal: the
recover-as-C path covers ~the whole ROM. The hand/system cluster lines up
with the drift-sensitive code already called out in Feature 2 (IRQ) — defer
those as a unit, recover the bulk.

Tools: `tools/classify_origin.py` (`--list`, `--by-file`),
`tools/origin_chart.py`.

---
_Last updated: 2026-05-31 09:24:57 -0400_
