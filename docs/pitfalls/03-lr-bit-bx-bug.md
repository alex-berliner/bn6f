# 03 — LR-bit BX mode-switch bug

**Class:** build-system / interworking
**Severity:** crash shortly after invoking patched function
**Status:** fix established (DECOMP_VTABLE_WRAPPER macro)

## Symptom

Decomp ROM crashes shortly after a converted function is invoked.
Probe shows PC jumping to an even address in IWRAM (stack region) or
to garbage. The orig ASM works fine; the converted C version is what
broke it.

The pattern is **always**: the converted function is referenced
indirectly somewhere in ASM (e.g. `.word symbol_name` in a vtable or
jumptable), and the caller dispatches via `mov lr, pc; bx rN` rather
than a direct `bl`.

## Why

GBA thumb-1 doesn't have `blx` (branch with link, with mode
interworking). To call a function pointer, the original compiler
emitted:

```
mov lr, pc       @ lr = address of next instruction
bx  rN           @ jump to rN; rN's bit 0 sets thumb/arm mode
```

The catch: in thumb mode, `mov lr, pc` sets LR to the next-instruction
address with **bit 0 = 0** (since the next instruction is at a
halfword-aligned address). When the callee eventually returns via
`bx lr`, the bx instruction interworks: bit 0 of LR determines whether
to switch to ARM mode (0) or stay in thumb (1).

So returning via `bx lr` with bit 0 = 0 → CPU **switches to ARM mode**
at whatever address LR points to. That address now contains thumb
instructions being interpreted as ARM instructions → garbage.

The orig ASM gets away with this because hand-written callees end with
`mov pc, lr`, which doesn't interwork — it just sets PC raw, keeping
CPSR.T as-is. So mode stays thumb regardless of LR bit 0.

But agbcc's C-function epilogue uses `pop {regs, pc}` (interworking on
ARMv5+; on ARMv4T it doesn't interwork either... but wait — agbcc's
epilogue is actually `pop {regs}; bx lr` in many cases, which DOES
interwork on all variants). That `bx lr` then switches mode based on
LR bit 0, exposing the bug.

## How to detect

If your patched C function ends up in a vtable or jumptable in the
ASM, you'll hit this. Check:

```sh
grep -E "\\.word\\s+${fn_name}(\\+1)?\\b" asm/
```

Any hit means the function is referenced indirectly. If a caller does
`mov lr, pc; bx rN` to dispatch through that vtable, the bug triggers.

## Fix

Wrap the C function with the `DECOMP_VTABLE_WRAPPER` macro
(`src/c/types.h`). The wrapper preserves LR across the call manually
using `mov pc, rN` instead of `bx rN` on return:

```c
static u32 fn_impl(args) {
    ...real C body...
}

DECOMP_VTABLE_WRAPPER(fn_name_c, fn_impl)
```

Expansion:

```c
__attribute__((naked)) void fn_name_c(void) {
    asm volatile(
        "push {lr}\n\t"
        "bl fn_impl\n\t"
        "pop {r3}\n\t"
        "mov pc, r3\n\t"   // NOT bx — keeps thumb mode regardless of LR bit 0
    );
}
```

Verified against `sub_81231E0` (vtable callee via `off_81211D0` in
`asm32.s`).

## When to apply

Search for `.word <symbol>` or `.word <symbol>+1` in `asm/*.s` before
shipping any patch. If hit, wrap. Otherwise the plain C function is
fine — direct `bl` callers don't have the LR-bit problem.

## Related

- `src/c/types.h` (macro definition)
- Memory: [[decomp_lr_bit_bx_bug]]
- `include/macros/function.inc` (decomp_trampoline)
