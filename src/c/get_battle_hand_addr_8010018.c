#include "types.h"

extern u8 byte_20349C0[];

// Returns &byte_20349C0[idx * 0x50]. Each hand record is 0x50 bytes.
u8 *getBattleHandAddr_8010018_c(u32 idx)
{
    return &byte_20349C0[idx * 0x50];
}
