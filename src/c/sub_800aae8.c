#include "types.h"

// r10 = ambient Toolkit*. Sets Toolkit.BattleStatePtr->Unk_3a (u16) = 1.
void sub_800AAE8_c(void)
{
    register u8 *r10p asm("r10");
    u8 *bs;
    asm volatile("" : "=r"(r10p));

    bs = *(u8 **)(r10p + 0x18);
    *(u16 *)(bs + 0x3a) = 1;
}
