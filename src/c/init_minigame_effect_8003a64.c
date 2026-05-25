#include "types.h"

extern void ZeroFillByWord_c(u32 *dst, u32 byte_count);

/* Twin of initScenarioEffect_8003914 — same shape but for the
 * minigame effect state at eStruct2001010 (0x02001010), with the
 * jump-table at off_80039F8 (0x080039F8). */
void initMinigameEffect_8003a64_c(u32 idx)
{
    u8 *p;
    u8 *jt;

    p = (u8 *) 0x02001010u;
    ZeroFillByWord_c((u32 *) p, 0x48u);
    p[1] = (u8)idx;
    jt = (u8 *) 0x080039F8u + (u32)p[1] * 16u;
    *(u32 *)(p + 4) = *(u32 *)(jt + 8);
    p[2] = jt[0xC];
    p[0] = 1u;
    p[3] = 1u;
}
