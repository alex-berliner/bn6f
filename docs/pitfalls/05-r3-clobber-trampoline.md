# 05 — r3 clobber by standard decomp_trampoline

**Class:** build-system / trampoline mechanics
**Severity:** can break callers that rely on r3 surviving
**Status:** alternate macro available (`decomp_trampoline_r3safe`)

## Symptom

A caller of a patched function reads a different r3 value than it
would have with the orig ASM. Concretely: orig writes r3 in the
callee (or leaves it from a preceding instruction), and a later
instruction in the caller reads r3 — but post-trampoline, r3 holds
the trampoline literal-pool address instead.

May manifest as wrong values stored to memory, wrong branch
decisions, or subtle data corruption depending on what the caller
does with the leaked r3.

## Why

The standard `decomp_trampoline` macro expands to:

```
ldr r3, =target_fn + 1   @ r3 := address of C target (low literal)
bx  r3                    @ jump to C target in thumb mode
.pool
```

`ldr r3, =...` clobbers r3 before the jump. After the C function
returns to the caller, r3 holds whatever value the trampoline's
literal-pool address was — typically a pointer like `0x087FE459`.

AAPCS technically allows this (r0-r3, r12 are caller-save), so a
strictly-conformant caller would have saved r3 before the `bl`. But
hand-written GBA ASM frequently relies on caller-save regs surviving
when the callee is written compactly — that's the project's de-facto
convention.

If the orig callee never touched r3 (many small functions don't),
the caller could legitimately expect r3 to survive. Trampolining
breaks that expectation.

## How to detect

Two ways:

**Grep for r3-live patterns near callers:**

```sh
grep -B2 -A6 'bl <fn_name>\b' asm/
```

Look for `mov r3, ...` or `<op> r3, ...` *before* the `bl`, and a
read of r3 *after* the `bl` without an intervening write. If found,
the caller depends on r3 surviving.

**Lockstep failure pattern:** if the divergence's `components`
include r3 and the orig vs decomp r3 values differ by an address in
the extension space (`0x087Fxxxx`), the trampoline's literal-pool
address has leaked into r3.

## Fix

Use `decomp_trampoline_r3safe` instead of `decomp_trampoline` in the
asm `.else` branch:

```
.else
    thumb_func_start fn_name
fn_name:
    decomp_trampoline_r3safe fn_name_c, 0
    thumb_func_end fn_name
.endif
```

The r3-safe variant:

```
push {r0}                @ save r0 (input arg)
ldr  r0, =target + 1     @ use r0 to load target
mov  r12, r0             @ park target in scratch hi reg
pop  {r0}                @ restore r0
bx   r12                 @ jump to C; r0..r3 preserved
.pool
```

Costs 6 more bytes and ~6 more cycles per call, but r3 (and r0)
survive the call uncorrupted.

## When to use which

| Pattern | Macro |
|---|---|
| Caller obviously doesn't read r3 after bl | `decomp_trampoline` |
| Caller reads r3 after bl, or you can't tell | `decomp_trampoline_r3safe` |
| Function takes 4 args (r0-r3 all live as inputs) | `decomp_trampoline_r3safe` |
| Unsure | start with `_r3safe`, downgrade later if performance matters |

The default in this project is `decomp_trampoline` (smaller, faster).
Use the r3-safe variant where r3-live callers are confirmed.

## Note: not the cause of trampoline cycle drift

It was tempting to blame r3 clobber for ByteFill's drift-class
divergence. We tested: swapping to `_r3safe` shifted the divergence
from frame 283 to frame 281 (the extra 6 cycles slightly worsened
drift) but didn't resolve it. The actual cause was cycle drift
itself (pitfall 02), not r3 clobber.

## Related

- `include/macros/function.inc` (both macro definitions)
- `docs/pitfalls/02-trampoline-cycle-drift.md`
