#include "types.h"

// r10 = ambient Toolkit*. Returns the u16 at offset 0x38 of
// Toolkit.BattleStatePtr (at Toolkit + 0x18). Halfword twin of
// sub_800A704.
u16 sub_800A70C_c(void)
{
    register u8 *r10p asm("r10");
    u8 *bs;
    asm volatile("" : "=r"(r10p));

    bs = *(u8 **)(r10p + 0x18);
    return *(u16 *)(bs + 0x38);
}
