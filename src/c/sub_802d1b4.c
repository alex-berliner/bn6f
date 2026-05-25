#include "types.h"

extern u32 sub_802D064(u32 idx);

// Returns byte at offset 0xd of the struct sub_802D064(idx) points at
// (sub_802D064 = 0x0203C4A0 + idx * 32).
u8 sub_802D1B4_c(u32 idx)
{
    return *((u8 *)sub_802D064(idx) + 0xd);
}
