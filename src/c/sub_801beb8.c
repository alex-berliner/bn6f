#include "types.h"

extern u8 eStruct2035280[];

// eStruct2035280[0x44..0x47] (u32) |= flag (dword_20352C4).
void sub_801BEB8_c(u32 flag)
{
    *(u32 *)&eStruct2035280[0x44] |= flag;
}
