#include "types.h"

// r10 = ambient Toolkit*. Returns the u32 at offset 0x18 of
// Toolkit.S2001c04Ptr (at Toolkit + 0x40).
u32 sub_8000E28_c(void)
{
    register u8 *r10p asm("r10");
    u8 *p;
    asm volatile("" : "=r"(r10p));

    p = *(u8 **)(r10p + 0x40);
    return *(u32 *)(p + 0x18);
}
