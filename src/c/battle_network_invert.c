#include "types.h"

// r10 = ambient Toolkit*. Returns r0 XOR Toolkit.BattleStatePtr->Unk_0d.
u8 battle_networkInvert_c(u8 a)
{
    register u8 *r10p asm("r10");
    u8 *bs;
    asm volatile("" : "=r"(r10p));

    bs = *(u8 **)(r10p + 0x18);
    return a ^ bs[0xd];
}
