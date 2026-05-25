#include "types.h"

// r5 = ambient BattleObject*. obj->CollisionDataPtr->ObjectFlags2 |= flag.
void object_setFlag2_c(u32 flag)
{
    register u8 *r5p asm("r5");
    u8 *cd;
    asm volatile("" : "=r"(r5p));

    cd = *(u8 **)(r5p + 0x54);
    *(u32 *)(cd + 0x40) |= flag;
}
