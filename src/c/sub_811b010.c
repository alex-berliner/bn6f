#include "types.h"

extern void sub_802FE6A_c(u32 idx);

/* Inlined inverse: if 0x02008450[idx] is non-empty AND its byte +0x11
 * has either of bits 0..1 set, call sprite_makeUnscalable with r5 =
 * slot ptr.  Inlined to avoid the cross-call r5 rebind (and the
 * getStructFrom2008450 Z-flag round-trip — same pattern as
 * sub_811BC00). */
void sub_811B010_c(u32 idx)
{
    u8 *p;
    u8 *spr;
    u8 v11;
    u8 v13;

    p = (u8 *) 0x02008450u + idx * 88u;
    if (*p == 0u) return;
    if ((p[0x11] & 3u) == 0u) return;

    /* sprite_makeUnscalable body inlined with r5 = p. */
    spr = p + (p[2] & 0xF0u);
    v11 = spr[0x11];
    if ((v11 & 3u) == 0u) return;
    spr[0x11] = v11 & (u8) ~3u;
    v13 = spr[0x13];
    spr[0x13] = v13 & (u8) ~0x3eu;
    sub_802FE6A_c((u32)((v13 & 0x3eu) >> 1));
}
