#include "types.h"

extern void InitializeStructsOfObjectType(u32 object_type);

#define OBJECT_TYPE_OW_NPC 2

void InitializeOverworldNPCObjectStructs_c(void)
{
    InitializeStructsOfObjectType(OBJECT_TYPE_OW_NPC);
}
