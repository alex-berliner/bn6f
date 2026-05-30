# 04 — Manifest + build flavors

## What it is

The plumbing that turns "this function is now C" into two ROMs from one
tree: a plain-text manifest of symbols, expanded into per-symbol
`--defsym` flags that gate the `.ifndef DECOMP_<sym>` blocks.

## How it works today

- **`tools/decomp_manifest.txt`** — one ASM symbol per line. 561 lines:
  23 comment lines, 534 active entries, 0 duplicates.
- **`make all`** — defines no `DECOMP_*` → every `.ifndef` keeps the
  original body → SHA-exact retail ROM. Uses `ld_script.ld`
  (rom @ 0x8000000, LENGTH 0x2000000).
- **`make decompile`** — generates 534 `--defsym DECOMP_<sym>=1` lines
  into `build/decomp_flags.txt`, passed to the assembler as `@FILE`;
  every gated block flips to the trampoline. Uses
  `ld_script_decompile.ld` = same script + a `c_code` region
  (@ 0x0A000000, LENGTH 0x2000000) for the compiled C bodies.
- C side: `build/c_ofiles.txt` lists the 489 `src/c/*.c` objects, passed
  to `ld` as `@FILE`. (534 manifest entries vs 489 files: the ~45 gap is
  multi-symbol files — e.g. a `DECOMP_FLAG_WRAPPER` impl+wrapper pair, or
  multi-entry-point functions, sharing one `.c`.)
- **`clean-conditional-objs`** force-removes `build/rom.o` and the flags
  file every build, because the flags-file's mtime dependency breaks
  under stash/restore (mv inherits an older mtime → make thinks the
  empty file is current). A real-bug workaround, documented in the
  Makefile.

## Strengths

- **Dead simple + transparent.** A text file you can read, grep, diff,
  and revert line-by-line. No DB, no codegen step to mistrust.
- The `@FILE` response-file trick keeps `make decompile` output to ~3
  lines instead of hundreds (was a token-spend win).
- Order-independent, comment-friendly.

## Weaknesses / open questions

- **No validation that a manifest entry is real.** Found a dangling
  entry: `ByteFill_Canary_TEST_ONLY_DO_NOT_SHIP_OOPS` — no `.ifndef`
  block, no `.c` file. It generates an unused `--defsym` and is
  otherwise inert. Harmless *this time*, but nothing catches a typo'd
  symbol → you'd get a silently-not-applied conversion (defsym set, no
  gate to match) and a "passing" validation that proved nothing.
- **Manifest ↔ asm ↔ c three-way consistency is unchecked.** The build
  trusts all three agree. A symbol in the manifest with no asm gate, or
  an asm gate with no manifest line, or a `.c` with no manifest entry —
  none of these error. (Ties to the canary-named cruft above.)
- **mtime fragility** is patched by always force-rebuilding rather than
  fixed at the dependency level.
- The `c_code` region is a fixed 0x2000000 window; overflow is a manual
  "bump LENGTH" per the pitfalls doc.

## Verdict

**RESTRUCTURE — split the two problems; keep the single `.o`.** (2026-05-30)

The mess came from conflating two separate problems. Treat them apart:

**A) Tracking which symbols to substitute → JSON file.**
Replace the flat `decomp_manifest.txt` with a structured JSON: one record
per conversion carrying everything (asm symbol, c file, pad, wrapper kind,
address, **enabled flag**). The enabled flag gives per-symbol on/off for
partial patch sets without moving or deleting files.

**B) Mechanically replacing the symbol → keep the `.ifndef` gate, but
stub them ALL once via a script.** Do NOT break the single `rom.o`
(automatic weak-symbol override is impossible in one translation unit,
and splitting threatens the SHA-exact build). Instead, a one-time script
wraps **every** function in the `.ifndef DECOMP_<sym> / orig / .else /
decomp_trampoline <sym>_c, <pad> / .endif` skeleton. After that:
- The `.else` branch only assembles when `DECOMP_<sym>=1` is set (only
  for enabled JSON records), so a stubbed-but-unconverted function is
  inert — always takes the original branch.
- Converting a function becomes: add the C file + flip its JSON record.
  **The `.s` files are never hand-edited again.**
- Bonus: the stub script auto-computes PAD from the ELF, killing the
  Feature 2 manual-pad footgun for the whole tree at once.

Drift becomes structurally impossible-ish: gates are machine-stamped
once, the JSON is the only thing edited per conversion, no second
hand-maintained list to disagree.

### Implementation risks to handle in the stub script
- **1380 functions carry embedded literal pools** in their body — the
  parser must find body extent correctly, not regex-naively.
- **`.pool` flush hazard** (Feature 2) — pad/pool interaction for
  data-carrying functions is the known-fragile part.
- 5 multi-entry (`thumb_local_start`) functions need manual handling.
- mtime/stash fragility + fixed `.c_code` region: left as-is (working
  workarounds, not worth touching now).

See [todo.md](todo.md) → "Feature 4".

---
_Last updated: 2026-05-30 11:33:24 -0400_
