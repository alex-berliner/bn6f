#include "types.h"

// r5 = ambient BattleObject*. Stores ((r1 << 8) | r0) as u16 at
// obj->CollisionDataPtr + 0x12. r0 and r1 are u8 args.
void sub_801A4D0_c(u8 lo, u8 hi)
{
    register u8 *r5p asm("r5");
    u8 *cd;
    asm volatile("" : "=r"(r5p));

    cd = *(u8 **)(r5p + 0x54);
    *(u16 *)(cd + 0x12) = ((u16)hi << 8) | lo;
}
