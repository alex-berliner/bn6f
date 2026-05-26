#include "EWRAM.h"
#include "types.h"

/* memcpy of u32s with overlap handling: if dst > src, copy backwards;
   else forward.  byte_count is in bytes (a multiple of 4) and must be
   > 0 for either branch — the forward loop falls through cleanly on 0,
   the reverse loop reads off the end when byte_count == 0. */
static void copyWords_80014EC_impl(u32 *src, u32 *dst, u32 byte_count)
{
    s32 n = (s32)byte_count;
    if ((u32)src < (u32)dst) {
        /* dst > src: copy backwards so the tail of src isn't
           overwritten before we read it. n must reach 0 (inclusive)
           but not go negative — `n >= 4` so the last iteration writes
           the head word (src[0] -> dst[0]). */
        u8 *s = (u8 *)src + (n - 4);
        u8 *d = (u8 *)dst + (n - 4);
        for (; n >= 4; n -= 4) {
            *(u32 *)d = *(u32 *)s;
            s -= 4;
            d -= 4;
        }
    } else {
        for (; n > 0; n -= 4) {
            *dst++ = *src++;
        }
    }
}

/* The ASM trampoline jumps here via `ldr r3, =copyWords_80014EC_c+1;
   bx r3`. Callers reach the trampoline via either a normal `bl
   copyWords_80014EC` (LR has bit 0 set) OR a `mov lr, pc; bx r3`
   indirect pattern through ToolkitExtraPtrs (LR has bit 0 CLEAR).
   The latter is incompatible with the `pop {rN}; bx rN` epilogue
   agbcc would emit for a plain C function — bx interworks on bit 0
   and would switch the caller back to ARM mode. The naked wrapper
   ends with `mov pc, rN` so the return preserves the caller's mode
   regardless of LR's bit 0. */
DECOMP_VTABLE_WRAPPER(copyWords_80014EC_c, copyWords_80014EC_impl)
