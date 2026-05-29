# 03 — Wrapper macros (ABI-hazard band-aids)

## What it is

Macros in `src/c/types.h` that fix cases where a plain agbcc-compiled C
function would return *wrong* when standing in for an ASM function.

- **`DECOMP_FLAG_WRAPPER`** (35 uses) — for callers doing `bl fn;
  beq/bne`. Emits naked `push {lr}; bl impl; tst r0, r0; pop {pc}` so the
  Z flag reflects the return value.
- **`DECOMP_VTABLE_WRAPPER`** (26 uses) — the LR-bit-bx fix
  ([[decomp_lr_bit_bx_bug]]). For functions dispatched via `mov lr, pc;
  bx rN` from a `.word <sym>` pointer table. Emits `push {lr}; bl impl;
  pop {r3}; mov pc, r3` to return mode-preserving.
- **Manual `__attribute__((naked))`** (26 files) — everything fitting
  neither pattern.

~87 of 489 C files (18%) need a hand-picked wrapper.

## The hazard (LR-bit-bx), in detail

A Thumb indirect-call site does `mov lr, pc; bx rN`. `mov lr, pc` stores
a 2-byte-aligned return address → **bit 0 = 0**. The original ASM callee
returns with `mov pc, lr` / `pop {pc}` which on ARMv4T is
**non-interworking** → ignores bit 0 → stays in Thumb → correct. An
agbcc-compiled C callee ends with `bx lr`, which **interworks on bit 0**
→ bit 0 = 0 → switches to **ARM mode** → caller's next Thumb bytes get
decoded as a 32-bit ARM instruction → silent corruption, surfacing later
and elsewhere. Verified cautionary tale: `sub_81231E0`, dispatched via
`off_81211D0` (`asm/asm32.s`).

Return-style distribution across `asm/` (why this matters): `pop {...pc}`
12928, `mov pc, lr` 923, `bx lr` only 71. The original toolchain returns
mode-preserving by default; `bx lr` is the rare deliberate case. There
are **1882 `mov lr, pc` indirect-call sites** still in ASM, so the hazard
surface is large and persistent.

## Discussion: could an agbcc change fix this? (2026-05-29)

Three options were sketched (UNVERIFIED — see verdict):
- **A. mode-preserving epilogue** — make agbcc emit `pop {pc}` / `mov pc,
  lr` (ideally via an opt-in function attribute) instead of `bx lr`,
  eliminating the `DECOMP_VTABLE_WRAPPER` class.
- **B. fault-aware build check** — a linter cross-referencing "symbol is
  `.word`-referenced in a pointer table" (the pin census) against
  "compiled by agbcc with `bx lr`"; error at build instead of silent
  runtime corruption. Doesn't touch agbcc's frontend.
- **C. both** — selector auto-applies attribute, linter verifies none
  slipped through; manual wrapper choice disappears.

Claimed (but NOT yet demonstrated): this is orthogonal to the SHA-exact
guarantee, because `make all` is pure ASM and agbcc only runs in the
already-non-matched `make decompile`. Memory [[decomp_no_agbcc_fork]]
cautions against forking agbcc — that caution targets the *matched*
build's ABI; needs revisiting in light of the above, but ONLY after the
demonstrator below confirms the premise.

## Verdict

**NO RESOLUTION YET — demonstrator required first.**

Author (Claude) has made multiple unverified claims this session
(fabricated IRQ symbols, inverted census numbers), so the epilogue
argument does not get to pass on assertion. Before deciding anything
about agbcc:

Build a minimal, reproducible **side-by-side demonstrator**:
- Same vtable-dispatched function, compiled two ways: (off) plain agbcc
  `bx lr` epilogue, (on) mode-preserving epilogue.
- Produce **two binaries**.
- With epilogue change OFF: **capture the actual failure** (validator
  diff / crash / wrong pixels / first_diff_frame).
- With it ON: show it passes.

If the demonstrator reproduces the failure off and fixes it on, the
agbcc-epilogue direction is proven and we revisit A/B/C + the
[[decomp_no_agbcc_fork]] memory. If it does NOT, the whole premise is
wrong and the wrappers stay as-is. See [todo.md](todo.md).

---
_Last updated: 2026-05-29 15:10:53 -0400_
