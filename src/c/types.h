#ifndef TYPES_H
#define TYPES_H

typedef unsigned char  u8;
typedef unsigned short u16;
typedef unsigned int   u32;
typedef unsigned long long u64;
typedef signed char    s8;
typedef signed short   s16;
typedef signed int     s32;
typedef u8             bool8;

// Flag-preserving wrapper: emits a naked function `WRAPPER_NAME`
// that calls IMPL_NAME and then issues `tst r0, r0` so the Z flag
// reflects the return value on exit. Used for ASM functions whose
// callers do `bl X; beq/bne ...` and depend on flag semantics that
// the regular C calling convention doesn't preserve.
//
// Both WRAPPER_NAME and IMPL_NAME land in .c_code, so the `bl` is
// in range (no need for an ldr+bx detour).
#define DECOMP_FLAG_WRAPPER(WRAPPER_NAME, IMPL_NAME)               \
    __attribute__((naked)) void WRAPPER_NAME(void)                 \
    {                                                              \
        asm volatile(                                              \
            "push {lr}\n\t"                                        \
            "bl " #IMPL_NAME "\n\t"                                \
            "tst r0, r0\n\t"                                       \
            "pop {pc}\n\t"                                         \
        );                                                        \
    }

// Vtable-callee wrapper: when our function is dispatched via the
// `mov lr, pc; bx rN` indirect-call pattern (e.g. through a function
// pointer table referenced by `.word <sym>` in data), `lr` is set
// WITHOUT the thumb bit. The original ASM returns via `mov pc, lr`,
// which preserves the current execution mode regardless of lr's
// bit 0. But agbcc-compiled C ends a leaf with `bx lr`, which
// INTERWORKS based on lr's bit 0 -> switches to ARM mode on return
// -> caller's next thumb instruction is decoded as ARM -> chaos.
//
// This wrapper saves the original (non-thumb-bit) lr, calls IMPL
// via a normal BL (so IMPL's `bx lr` returns inside the wrapper),
// then returns to the original caller via `mov pc, rN` (no
// interworking) — preserves thumb mode.
//
// Verified against `sub_81231E0` (vtable callee via `off_81211D0`
// in asm32.s) — passes after fixing a pool-leakage bug in
// `decomp_trampoline` (see include/macros/function.inc).
//
// To use: grep `.word <sym>` asm/*.s — if hit, this wrapper is
// the right tool.
#define DECOMP_VTABLE_WRAPPER(WRAPPER_NAME, IMPL_NAME)             \
    __attribute__((naked)) void WRAPPER_NAME(void)                 \
    {                                                              \
        asm volatile(                                              \
            "push {lr}\n\t"                                        \
            "bl " #IMPL_NAME "\n\t"                                \
            "pop {r3}\n\t"                                         \
            "mov pc, r3\n\t"                                       \
        );                                                        \
    }

#endif
