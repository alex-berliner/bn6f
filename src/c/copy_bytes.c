#include "types.h"

/* Dispatched from CopyJumpTable8000AA8 in asm/asm00_0.s via the
   `mov lr, pc; bx r3` indirect-call pattern, so LR has bit 0 = 0.
   Wrap with DECOMP_VTABLE_WRAPPER — see decomp_lr_bit_bx_bug memory. */
static void CopyBytes_impl(const u8 *src, u8 *dst, u32 count)
{
    while (count-- > 0) {
        dst[count] = src[count];
    }
}

DECOMP_VTABLE_WRAPPER(CopyBytes_c, CopyBytes_impl)
