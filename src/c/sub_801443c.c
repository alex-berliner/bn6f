#include "types.h"

// r5 = ambient BattleObject*. Stores 0xffff as u16 at
// obj->AIDataPtr->Unk_32. Twin of sub_8014446 (which writes 0).
void sub_801443C_c(void)
{
    register u8 *r5p asm("r5");
    u8 *ai;
    asm volatile("" : "=r"(r5p));

    ai = *(u8 **)(r5p + 0x58);
    *(u16 *)(ai + 0x32) = 0xffff;
}
