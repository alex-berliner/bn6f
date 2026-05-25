#include "types.h"

extern u32 BattleSettings_200AF60[];

// BattleSettings_200AF60.UnknownOptionalSettings (offset 0x8 as u32) |= flag.
void battleSettings_setFlags_unkSettings_c(u32 flag)
{
    BattleSettings_200AF60[2] |= flag;
}
