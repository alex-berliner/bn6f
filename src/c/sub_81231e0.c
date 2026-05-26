#include "types.h"

extern u16 word_200DCF0;

// word_200DCF0[6] = 1 (offset 0xc as u16).
//
// Dispatched via off_81211D0 vtable in asm32.s — caller uses
// `mov lr, pc; bx rN` which sets lr WITHOUT the thumb bit. Wrapped
// via DECOMP_VTABLE_WRAPPER so the return uses `mov pc, rN` (no
// interworking) instead of `bx lr` (would switch to ARM mode).
void sub_81231E0_impl(void)
{
    (&word_200DCF0)[6] = 1;
}

DECOMP_VTABLE_WRAPPER(sub_81231E0_c, sub_81231E0_impl)
