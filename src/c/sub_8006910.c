#include "types.h"

extern u8 byte_20081B0;

static void sub_8006910_impl(void)
{
    byte_20081B0 = 0x80;
}

DECOMP_VTABLE_WRAPPER(sub_8006910_c, sub_8006910_impl)
