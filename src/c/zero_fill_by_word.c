#include "types.h"

// Zero-fill specialization of WordFill (BIOS SWI_CpuSet word-mode
// with a hardcoded zero source).
//
// Args: r0=dst, r1=byte_count.
static void ZeroFillByWord_impl(u32 *dst, u32 byte_count)
{
    u32 words = byte_count >> 2;
    u32 i;
    for (i = 0; i < words; i++) {
        dst[i] = 0;
    }
}

DECOMP_VTABLE_WRAPPER(ZeroFillByWord_c, ZeroFillByWord_impl)
