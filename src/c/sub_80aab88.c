#include "types.h"

/* For i in 0..0x27: dst[i] = ~(a[i] | b[i]).  (40-byte NOR copy.) */
void sub_80AAB88_c(u8 *a, u8 *b, u8 *dst)
{
    s32 i;
    for (i = 0; i < 0x28; i++) {
        dst[i] = (u8) ~(a[i] | b[i]);
    }
}
