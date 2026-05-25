#include "types.h"

extern u32 sub_813B780_c(u32 idx);

/* Scan 4 entries of the 16-byte struct table backing
 * sub_813B780, starting at index `base - 0x90`.  Returns
 * (base + i) for the first entry whose byte +3 equals `wanted`, or
 * 0 if none match. */
u32 sub_803D148_c(u32 base, u32 wanted)
{
    u32 lo;
    u32 i;
    u8 *p;

    lo = base - 0x90u;
    for (i = 0u; i < 4u; i++) {
        p = (u8 *) sub_813B780_c(lo + i);
        if (p[3] == (u8)wanted) {
            return base + i;
        }
    }
    return 0u;
}
