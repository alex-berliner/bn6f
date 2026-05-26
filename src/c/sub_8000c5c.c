#include "EWRAM.h"

/* If x == 0 return 1.  Otherwise count how many right-shifts-by-4
   it takes to reach 0 (i.e. the number of significant hex digits). */
static u32 sub_8000C5C_impl(u32 x)
{
    u32 n;
    if (x == 0u) return 1u;
    n = 0u;
    while (x != 0u) {
        n++;
        x >>= 4;
    }
    return n;
}

DECOMP_VTABLE_WRAPPER(sub_8000C5C_c, sub_8000C5C_impl)
