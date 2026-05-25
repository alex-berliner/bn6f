#include "types.h"

extern u8 *GetBattleNaviStatsAddr(u8 alliance);

// r5 = ambient BattleObject*. Returns NaviStats[obj->Alliance][off] as u16.
u16 GetBattleNaviStatsHword_AllianceFromBattleObject_c(u32 _unused, u32 off)
{
    register u8 *r5p asm("r5");
    asm volatile("" : "=r"(r5p));
    (void)_unused;

    return *(u16 *)(GetBattleNaviStatsAddr(r5p[0x16]) + off);
}
