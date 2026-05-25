#include "types.h"

extern u8 *GetBattleNaviStatsAddr(u8 alliance);

// r5 = ambient BattleObject*. NaviStats[obj->Alliance][off] = (u8)val.
void SetBattleNaviStatsByte_AllianceFromBattleObject_c(u32 _unused, u32 off, u8 val)
{
    register u8 *r5p asm("r5");
    asm volatile("" : "=r"(r5p));
    (void)_unused;

    GetBattleNaviStatsAddr(r5p[0x16])[off] = val;
}
