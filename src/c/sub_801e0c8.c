#include "types.h"

extern u8 eStruct2035280[];

// Stores `val` as a u16 at eStruct2035280 + 0x26 (word_20352A6).
void sub_801E0C8_c(u16 val)
{
    *(u16 *)(eStruct2035280 + 0x26) = val;
}
