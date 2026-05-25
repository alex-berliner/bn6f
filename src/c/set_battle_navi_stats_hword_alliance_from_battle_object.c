#include "types.h"

extern u8 *GetBattleNaviStatsAddr(u8 alliance);

// r5 = ambient BattleObject*. *(u16 *)&NaviStats[obj->Alliance][off] = val.
void SetBattleNaviStatsHword_AllianceFromBattleObject_c(u32 _unused, u32 off, u16 val)
{
    register u8 *r5p asm("r5");
    asm volatile("" : "=r"(r5p));
    (void)_unused;

    *(u16 *)(GetBattleNaviStatsAddr(r5p[0x16]) + off) = val;
}
