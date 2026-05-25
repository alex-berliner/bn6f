#include "types.h"

extern u8 eStruct203F7D8[];

// Zero the first byte of eStruct203F7D8.
void sub_801FE64_c(void)
{
    eStruct203F7D8[0] = 0;
}
