#include "types.h"

extern void ZeroFillByWord_c(u32 *dst, u32 byte_count);

// Thin wrapper: zero-fill 0x10 bytes at `dst`.
void sub_801299C_c(u32 *dst)
{
    ZeroFillByWord_c(dst, 0x10);
}
