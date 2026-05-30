# 09 — wrap_decomp.py (conversion automation)

## What it is

`tools/wrap_decomp.py <SYMBOL>` automates the mechanical setup of a
conversion: finds the function in `asm/*.s`, computes PAD, wraps it in
`.ifndef DECOMP_<sym> / .else / decomp_trampoline <sym>_c,<pad> / .endif`,
emits a `src/c/<snake>.c` stub, and appends the symbol to the manifest.
Idempotent (detects existing `.ifndef`).

## Strengths

- Automates exactly the 3-place edit that causes drift (asm gate + c file
  + manifest) — the right *intent*, and a direct precursor to the
  Feature 5 "stub all gates once" idea (this is the per-function version).
- PAD auto-computed from the orig ELF (objdump) — removes the manual-PAD
  footgun for the functions it handles.
- Idempotent re-run.

## Weaknesses / open questions

- **Not used anywhere.** No reference in docs, skills, ci, or the (now
  deleted) decomp-step loop. Orphaned like several other tools.
- **No wrapper-kind handling.** Zero awareness of VTABLE/FLAG/naked
  (Feature 3). It always emits a plain `void <sym>_c(void)` stub and a
  plain trampoline — so for any `.word`-dispatched or flag-dependent
  function it produces a silently-wrong scaffold. It doesn't even detect
  the `.word <sym>` case to warn.
- **PAD only does `- 8`.** The docs' `-10` case (2-aligned-but-not-4
  start, where `.pool` adds 2 bytes) is not handled → wrong PAD on those.
- **`snake_case` is broken** for the project's actual symbol shapes, and
  it has **already caused real damage**:
  - `sub_802FDB0` → `sub_802_f_d_b0`; `QueueWordAlignedGFXTransfer` →
    `queue_word_aligned_g_f_x_transfer` (caps runs + hex digits mangled).
  - **Live consequence:** `src/c/` contains BOTH `call_b_g_scroll_callback0.c`
    (mangled) AND `call_bg_scroll_callback0.c` (hand-fixed), for all 4
    `CallBGScrollCallback{0..3}`. Both `#define`-style define the SAME
    symbol `CallBGScrollCallback0_c`. Two definitions of one symbol in
    the agbcc-linked `.c_code` (no gc-sections) is a **duplicate-symbol
    hazard** — needs verifying whether `make decompile` currently links,
    and which file is the intended one. (Verify, don't assume.)
- **Stub signature is always `(void)`** — never reflects the real arg
  count, so every conversion starts from a wrong prototype.
- **Generic objdump symbol-size** can mis-handle multi-entry functions
  (Feature 2's `thumb_local_start` cases).

## Relationship to the new design

This tool is the per-function ancestor of:
- Feature 5 (stub ALL gates once) — supersedes the asm-wrap half.
- Feature 4 (JSON manifest) — supersedes the manifest-append half.
- Feature 1 (candidate selector) — would feed it.
So most of wrap_decomp's job gets absorbed by the redesign; what's worth
keeping is the *idea* + the PAD computation, not this implementation.

## Verdict

_pending_

---
_Last updated: 2026-05-30 13:15:11 -0400_
