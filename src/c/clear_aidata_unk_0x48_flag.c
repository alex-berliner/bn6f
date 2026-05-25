#include "types.h"

// r5 = ambient BattleObject*. obj->AIDataPtr->Unk_48 &= ~flag.
void ClearAIDataUnk0x48Flag_c(u32 flag)
{
    register u8 *r5p asm("r5");
    u8 *ai;
    asm volatile("" : "=r"(r5p));

    ai = *(u8 **)(r5p + 0x58);
    *(u32 *)(ai + 0x48) &= ~flag;
}
