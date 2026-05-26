#include "types.h"

/* Dispatched from CopyJumpTable8000AA8 (asm00_0.s) via `mov lr, pc;
   bx r3` — wrap with DECOMP_VTABLE_WRAPPER to preserve caller mode. */
static void CopyHalfwords_impl(const u16 *src, u16 *dst, u32 byte_count)
{
    u32 halfwords = byte_count >> 1;
    u32 i;
    for (i = 0; i < halfwords; i++) {
        dst[i] = src[i];
    }
}

DECOMP_VTABLE_WRAPPER(CopyHalfwords_c, CopyHalfwords_impl)
