#include "types.h"

extern u8 eStruct2035280[];

// eStruct2035280[0x40..0x43] (u32) |= flag (dword_20352C0).
void sub_801BECC_c(u32 flag)
{
    *(u32 *)&eStruct2035280[0x40] |= flag;
}
