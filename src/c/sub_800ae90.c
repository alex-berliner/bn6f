#include "types.h"

extern void PlaySoundEffect(u32 id);
extern void sub_8009FF8(u32 a0, u32 a1, u32 a2, u32 a3);

// Spawn a particle/sprite at (x, y), with a sound effect on certain
// frame phases. Clamps to a screen rectangle and bails silently if
// out of bounds.
//
// r10 = ambient Toolkit*. Toolkit.CurFramePtr is read twice (matching
// original ASM); the first read gates a sound effect when the frame
// counter low nibble == 0; the second read picks the sub_8009FF8
// "kind" argument from bit 3 of the frame counter (alternating 0xd3ca
// vs 0xd3cb each 8 frames).
//
// The sub_8009FF8 args 0/1 pack as: arg0 = ((x | 0x4000) << 16) | y,
// arg1 = kind, arg2/3 = 0.
void sub_800AE90_c(u32 x, u32 y)
{
    register u8 *r10p asm("r10");
    u8 *cf;
    u32 packed;
    u32 kind;
    asm volatile("" : "=r"(r10p));

    cf = *(u8 **)(r10p + 0x24);              // Toolkit.CurFramePtr
    if ((*(u16 *)cf & 0xf) == 0) {
        PlaySoundEffect(0x91);
    }

    if (x + 0x10 >= 0xff) return;
    if (y + 0x10 >= 0xb0) return;

    cf = *(u8 **)(r10p + 0x24);              // re-read
    kind = 0xd3ca + ((*(u16 *)cf & 8) >> 1);

    packed = ((x | 0x4000) << 16) | y;
    sub_8009FF8(packed, kind, 0, 0);
}
