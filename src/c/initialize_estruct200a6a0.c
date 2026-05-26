#include "types.h"

extern u8 eStruct200a6a0[];
extern void ZeroFillByWord_c(u32 *dst, u32 byte_count);

// Zero-fill 0x50 bytes of eStruct200a6a0, then store the three args
// at offsets 4/8/c and set the initialized flag at offset 0.
void Initialize_eStruct200a6a0_c(u32 a, u32 b, u32 c)
{
    ZeroFillByWord_c((u32 *)eStruct200a6a0, 0x50);
    *(u32 *)&eStruct200a6a0[0x4] = a;
    *(u32 *)&eStruct200a6a0[0x8] = b;
    *(u32 *)&eStruct200a6a0[0xc] = c;
    eStruct200a6a0[0] = 1;
}
