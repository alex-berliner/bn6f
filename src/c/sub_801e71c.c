#include "types.h"

extern u8 eStruct2035280[];

// Stores `val` (u8) at eStruct2035280 + 0x12 (byte_2035292).
void sub_801E71C_c(u8 val)
{
    eStruct2035280[0x12] = val;
}
