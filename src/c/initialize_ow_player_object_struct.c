#include "types.h"

extern void InitializeStructsOfObjectType(u32 object_type);

#define OBJECT_TYPE_OW_PLAYER 0

void InitializeOWPlayerObjectStruct_c(void)
{
    InitializeStructsOfObjectType(OBJECT_TYPE_OW_PLAYER);
}
