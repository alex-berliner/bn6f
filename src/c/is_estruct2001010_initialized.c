#include "types.h"

extern u8 eStruct2001010[];

u32 Is_eStruct2001010_Initialized_impl(void)
{
    return eStruct2001010[0];
}

DECOMP_FLAG_WRAPPER(Is_eStruct2001010_Initialized_c, Is_eStruct2001010_Initialized_impl)
