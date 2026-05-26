#include "types.h"

// r10 = ambient Toolkit*. Returns Toolkit.GameStatePtr->Unk_74 (u32).
u32 sub_8006DEC_c(void)
{
    register u8 *r10p asm("r10");
    u8 *gs;
    asm volatile("" : "=r"(r10p));

    gs = *(u8 **)(r10p + 0x3c);
    return *(u32 *)(gs + 0x74);
}
