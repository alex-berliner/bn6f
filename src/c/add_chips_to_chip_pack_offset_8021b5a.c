#include "types.h"

/* Returns r3 (status), mutates *p. r1 (the second arg) is unused.
 * Status: 0=added, 1=already at cap (99), 2=clamped to 99 from add.
 *
 * Two ABI-critical details the previous C version missed:
 *
 * 1. The orig ASM puts status in **r3**, not r0. Both callers in
 *    asm/asm02.s do `mov r0, r3` after the `bl`, so AAPCS-style
 *    return-in-r0 doesn't reach them. We use a naked wrapper to set
 *    r3 from the impl's r0 return before returning.
 *
 * 2. The orig comparison is 32-bit signed (`add r1, r1, r2; cmp r1, #99;
 *    ble`), not u8. Casting `v + add_qty` to u8 before the compare
 *    wraps at 256 and the bk2 caller (which passes large add_qty in
 *    some flows) gets a different stored byte than orig.
 *
 *     ldrb r1, [r0]      ; r1 = (u32)*p
 *     cmp  r1, #99
 *     beq  loc_8021B6E   ; status=1, write unchanged
 *     mov  r3, #0        ; status=0
 *     add  r1, r1, r2    ; 32-bit add, NOT u8
 *     cmp  r1, #99
 *     ble  loc_8021B6E   ; SIGNED comparison
 *     mov  r1, #99
 *     mov  r3, #2        ; status=2 (clamped)
 *   loc_8021B6E:
 *     strb r1, [r0]
 *     mov  pc, lr
 */
static u32 addChipsToChipPackOffset_8021b5a_impl(u8 *p, u32 r1, u32 add_qty)
{
    u32 v;
    s32 sum;
    (void)r1;
    v = (u32)*p;
    if (v == 99u) {
        return 1u;
    }
    sum = (s32)(v + add_qty);
    if (sum <= 99) {
        *p = (u8)sum;
        return 0u;
    }
    *p = 99u;
    return 2u;
}

/* The orig leaves all of r0..r3 in caller-readable state:
 *   r0 = dst (unchanged from entry)
 *   r1 = written byte value
 *   r2 = add_qty (unchanged)
 *   r3 = status
 * Both ASM callers in asm02.s chain a `bl setUnkFieldOfChipCode...`
 * right after, which uses r0 as its dst pointer — so r0 has to stay
 * as the original dst, not get clobbered with the C return value.
 * Save r0+r2 across the impl call, then reload r1 from *dst (matches
 * orig's "r1 == byte just stored" exit state), and put status in r3. */
__attribute__((naked)) void addChipsToChipPackOffset_8021b5a_c(void)
{
    asm volatile(
        "push {r0, r2, lr}\n\t"
        "bl addChipsToChipPackOffset_8021b5a_impl\n\t"
        "mov r3, r0\n\t"
        "pop {r0, r2}\n\t"
        "ldrb r1, [r0]\n\t"
        "pop {pc}\n\t"
    );
}
