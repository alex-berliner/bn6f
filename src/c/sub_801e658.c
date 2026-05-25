#include "types.h"

extern u8 eStruct2035280[];

// Zero the byte at eStruct2035280 + 0x1e (byte_203529E).
void sub_801E658_c(void)
{
    eStruct2035280[0x1e] = 0;
}
