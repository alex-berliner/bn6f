# 09 — wrap_decomp.py (conversion automation)

> NOTE: this file was rewritten 2026-05-30 after the first draft made
> several fabricated claims (see "Correction" at bottom). This version is
> checked against the actual source.

## What it is

`tools/wrap_decomp.py <SYMBOL>` automates the **asm-side** wiring of a
conversion. It explicitly does NOT touch the C file (docstring: "The C
file is the caller's responsibility; this script only does the asm-side
wiring"). Steps:

1. Look up size + addr from `bn6f_orig.elf` (`objdump -t`, mtime-cached).
2. Find the `thumb_func_start/end <SYMBOL>` block in `asm/*.s`.
3. Wrap it in `.ifndef DECOMP_<sym> / .else / decomp_trampoline
   <sym>_c,<pad> / .endif`.
4. Append `<SYMBOL>` to the manifest (idempotent).
5. Audit `bl <SYMBOL>` callers for flag-dependence; **hard-exit (code 2)
   unless `--force-flagdep`**.

## Strengths (verified against source)

- **PAD is computed correctly, incl. alignment cases.**
  `trampoline_bytes_for()` returns 8 (4-aligned) / 10 (2-aligned), and
  16/14 for the `--r3safe` variant. The `-10` case the docs warn about IS
  handled.
- **Flag-dependent callers are detected and BLOCK** the wrap (exit 2)
  until `--force-flagdep` — the FLAG hazard from Feature 3 is at least
  guarded against, not ignored.
- **Multi-entry functions** handled via `--from-label` (wraps only the
  shared tail, leaves the prelude).
- **Shared literal pools** audited (`audit_pool_sharing`): if a pool label
  inside the body is referenced from outside, the `.else` branch keeps the
  pool in both branches so its address is preserved — directly mitigates
  the `.pool`-flush hazard from Feature 2.
- **`--r3safe`** for 4-arg functions (r0..r3 live).
- objdump cache shared with other tools.
- Idempotent (detects existing `.ifndef`).
- Referenced in `AGENTS.md` + `token_todo.md` (it's a documented tool,
  not orphaned).

## Weaknesses / open questions

- **No VTABLE-wrapper handling.** It guards the FLAG case but does NOT
  detect `.word <sym>` / vtable dispatch (the LR-bit hazard, Feature 3) —
  no warning, no wrapper. That's the one ABI hazard class it misses.
- **Asm-side only.** The C file (and its correct signature/wrapper) is
  fully manual — so the drift surface between asm/manifest (automated) and
  the C file (manual) remains.
- **Superseded in part by the redesign:** Feature 5 (stub ALL gates once)
  absorbs the per-function asm-wrap; Feature 4 (JSON manifest) absorbs the
  manifest-append. The valuable, non-trivial logic to PRESERVE from this
  tool: `trampoline_bytes_for` (alignment-aware PAD), `audit_pool_sharing`
  (the pool-flush mitigation), `--from-label` multi-entry, and the
  flag-caller audit. Those should be lifted into the Feature 5 bulk
  stubber rather than rewritten.

## Verdict

_pending_

## Correction (process note)

First draft of this file claimed: PAD only does `-8` (FALSE — handles 10/
14/16); no FLAG awareness (FALSE — audits + blocks); generates a broken
snake_case C stub (FABRICATED — it generates no C file); a duplicate
`call_b_g_scroll_callback0.c` exists (FALSE — only `call_bg_...` exists);
"not used anywhere" (FALSE — in AGENTS.md). All committed before
verification. Corrected here. Lesson reinforced:
[[feedback_verify_before_claiming]] — describe code from the source, not
from a guess about what a tool "probably" does.

---
_Last updated: 2026-05-30 13:16:27 -0400_
