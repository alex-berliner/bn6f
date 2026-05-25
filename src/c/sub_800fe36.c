#include "types.h"

/* r5 = ambient BO*.  Classify the navi by AIData.Unk_0c into tiers,
 * gated on Version_16 being 4:
 *
 *   Version_16 != 4 → return Version_16 (the asm falls out leaving
 *                     r0 holding the just-loaded byte)
 *   Version_16 == 4:
 *     Unk_0c <= 3 → 0
 *     Unk_0c <= 6 → 1
 *     else        → 2
 */
u32 sub_800FE36_c(void)
{
    register u8 *r5p asm("r5");
    u8 *bo;
    u8 *ai;
    u32 ver;
    s32 unk0c;

    asm volatile("" : "=r"(r5p));
    bo = r5p;
    ai = *(u8 **)(bo + 0x58);
    ver = ai[0x16];
    if (ver != 4u) return ver;

    unk0c = (s32)(s8)ai[0x0c];
    if (unk0c <= 3) return 0u;
    if (unk0c <= 6) return 1u;
    return 2u;
}
