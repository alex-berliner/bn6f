#include "types.h"

// r5 = ambient BattleObject*. obj->AIDataPtr->Unk_44 |= flag.
void SetAIData_Unk_44_Flag_c(u32 flag)
{
    register u8 *r5p asm("r5");
    u8 *ai;
    asm volatile("" : "=r"(r5p));

    ai = *(u8 **)(r5p + 0x58);
    *(u32 *)(ai + 0x44) |= flag;
}
