# 04 — Manifest (tracking WHICH symbols to substitute)

> Split from the old combined "manifest + build flavors" feature on
> 2026-05-30. This feature is **problem A only**: the list of what to
> convert. The mechanism that performs the swap is Feature 05.

## What it is

`tools/decomp_manifest.txt` — a flat text list, one ASM symbol per line,
that records which functions are "converted to C". 547 lines: 12
comments, 534 active entries, 0 duplicates. `make decompile` turns each
active line into `--defsym DECOMP_<sym>=1`.

## Strengths

- Dead simple, greppable, diffable, revert-by-line.
- Order-independent, comment-friendly.

## Weaknesses

- **Unstructured.** A line is just a name; pad, wrapper kind, c-file,
  address, and enabled/disabled all live implicitly elsewhere or not at
  all.
- **No per-symbol on/off** without deleting the line.
- **Drift is possible** (see Feature 05): a manifest line can name a
  symbol with no asm gate and no C impl. Found 6 such entries
  (`ClearEventFlagFromImmediate` @ `tools/decomp_manifest.txt:21`, etc.)
  — claimed converted, actually still ASM, nothing reports it.

## Verdict

**RESTRUCTURE → JSON manifest.** (2026-05-30)

Replace the flat file with structured JSON: one record per conversion
carrying `{asm_symbol, c_file, pad, wrapper_kind, address, enabled}`. The
`enabled` flag gives per-symbol on/off for partial patch sets without
moving or deleting files. The build derives `--defsym` + the c-ofile list
from the JSON.

Goal (with Feature 05): make drift **impossible by construction**, not
something scanned for — the JSON is the single thing edited per
conversion; gates are machine-stamped once and never hand-touched.

See [todo.md](todo.md) → "Feature 4".

---
_Last updated: 2026-05-30 11:36:22 -0400_
