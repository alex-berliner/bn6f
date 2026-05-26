#include "types.h"

extern u8 eStruct200BC30_getJumpOffset00_c(void);

/* IMPL: same behavior as orig — push lr, call inner, pop pc. The orig
   was called via the `mov lr, pc; bx r0` indirect pattern through
   off_3005D20 (asm38.s), which leaves LR with bit 0 = 0. A plain C
   function would epilogue with `pop {rN}; bx rN` — interworks on bit 0
   and switches the caller back to ARM mode. Use the vtable-callee
   wrapper so the return preserves caller mode via `mov pc, rN`. */
static u8 eStruct200BC30_getJumpOffset00_pushpop_impl(void)
{
    return eStruct200BC30_getJumpOffset00_c();
}

DECOMP_VTABLE_WRAPPER(eStruct200BC30_getJumpOffset00_pushpop_c,
                     eStruct200BC30_getJumpOffset00_pushpop_impl)
