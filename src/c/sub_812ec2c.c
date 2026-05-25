#include "types.h"

extern void sub_811BC00_c(u32 a, u32 c, u32 idx, u32 b);

/* Forward (low-15-bit masked) `arg0`, `idx`, and `c` into
 * sub_811BC00 with b = 0, then return the masked `arg0` (the
 * original ASM lsl/lsr-17 dance zero-extends bits 0..14). */
u32 sub_812EC2C_c(u32 arg0, u32 idx, u32 c)
{
    u32 masked;
    masked = (arg0 << 17) >> 17;
    sub_811BC00_c(masked, c, idx, 0u);
    return masked;
}
