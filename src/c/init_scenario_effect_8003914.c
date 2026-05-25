#include "types.h"

extern void ZeroFillByWord_c(u32 *dst, u32 byte_count);

/* Initialise eScenarioEffectState2000780 (0x02000780) for scenario
 * index `idx`:
 *
 *   - Zero-fill 0x48 bytes
 *   - state[1]  = idx
 *   - jt        = jt_80038E8 (0x080038E8) + idx * 16
 *   - state[4]  = u32  jt[+8]
 *   - state[2]  = u8   jt[+0xC]
 *   - state[0]  = 1
 *   - state[3]  = 1
 */
void initScenarioEffect_8003914_c(u32 idx)
{
    u8 *p;
    u8 *jt;

    p = (u8 *) 0x02000780u;
    ZeroFillByWord_c((u32 *) p, 0x48u);
    p[1] = (u8)idx;
    jt = (u8 *) 0x080038E8u + (u32)p[1] * 16u;
    *(u32 *)(p + 4) = *(u32 *)(jt + 8);
    p[2] = jt[0xC];
    p[0] = 1u;
    p[3] = 1u;
}
