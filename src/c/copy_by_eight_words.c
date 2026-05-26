#include "types.h"

/* Dispatched from CopyJumpTable8000AA8 (asm00_0.s) via `mov lr, pc;
   bx r3` — wrap with DECOMP_VTABLE_WRAPPER to preserve caller mode. */
static void CopyByEightWords_impl(const u32 *src, u32 *dst, u32 byte_count)
{
    u32 words = byte_count >> 2;
    u32 i;
    for (i = 0; i < words; i++) {
        dst[i] = src[i];
    }
}

DECOMP_VTABLE_WRAPPER(CopyByEightWords_c, CopyByEightWords_impl)
