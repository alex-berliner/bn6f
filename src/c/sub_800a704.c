#include "types.h"

// r10 = ambient Toolkit*. Returns the u32 at offset 0x40 of
// Toolkit.BattleStatePtr (at Toolkit + 0x18).
u32 sub_800A704_c(void)
{
    register u8 *r10p asm("r10");
    u8 *bs;
    asm volatile("" : "=r"(r10p));

    bs = *(u8 **)(r10p + 0x18);
    return *(u32 *)(bs + 0x40);
}
