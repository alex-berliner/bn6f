# 09 — wrap_decomp.py (conversion automation)

> Checked against the actual source (`tools/wrap_decomp.py`). An earlier
> draft of this file was fabricated and rewritten; see
> [[feedback_verify_before_claiming]].

## What it is

`tools/wrap_decomp.py <SYMBOL>` automates the **asm-side** wiring to
convert one ASM function to C. The toolkit replaces a function's ASM body
with a tiny **trampoline** that jumps to the C reimplementation
(`<sym>_c`), gated by `.ifndef DECOMP_<sym>` so the same `rom.o` still
builds byte-identical when the C is switched off. This script does that
wiring for a single function; the C file itself is written by hand.

## What one invocation does

1. Looks up the function's size + address from `bn6f_orig.elf` (objdump,
   mtime-cached).
2. Finds its `thumb_func_start/end` block in `asm/*.s`.
3. Replaces the body with the trampoline + computed PAD so the slot keeps
   its exact original length (nothing after it shifts).
4. Appends `<SYMBOL>` to `tools/decomp_manifest.txt` (idempotent).
5. Audits `bl <SYMBOL>` callers for flag-dependence and **hard-exits
   (code 2)** unless `--force-flagdep`.

## The parts that make it non-trivial

- **Alignment-aware PAD** — the trampoline footprint is 8/10 bytes (or
  14/16 with `--r3safe` for 4-arg functions) depending on start alignment,
  because the trailing `.pool` may add a balign pad. Computed correctly.
- **Shared literal pools** — if a function's constants are referenced from
  outside, it keeps the pool in both branches so those references don't
  dangle (mitigates the Feature 2 `.pool`-flush hazard).
- **Multi-entry functions** — `--from-label` wraps only the shared tail.
- **Flag-caller gate** — blocks conversions whose callers depend on
  return-flags the validator can't see.

## Notable gap

It guards the FLAG hazard but does **not** detect VTABLE / `.word <sym>`
membership (indirect-call targets), which need `DECOMP_VTABLE_WRAPPER` —
so a vtable-dispatched function can be wrapped and ship a latent LR-bit
crash with no warning ([[decomp_lr_bit_bx_bug]]).

## Where it sits in the redesign

Superseded by later verdicts: Feature 5 (stub all gates once) absorbs the
per-function wrap, Feature 4 (JSON manifest) absorbs the append. So there
is no reason to review or maintain this tool further.

## Verdict

**RETIRE — do not harvest its code.** Its everyday job disappears under
Features 4 + 5, and the new bulk stubber is to be **written fresh**. The
hard cases this tool surfaced (alignment-aware PAD, shared-pool handling,
multi-entry tails, flag-caller detection, and the missing VTABLE/`.word`
detection) are recorded as **concerns** for Feature 5 to solve from
scratch — see [05](05-asm-ifndef-gating.md) and [todo.md](todo.md) →
Feature 5 — not as code to lift from here.

---
_Last updated: 2026-05-31 08:13:14 -0400_
