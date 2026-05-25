#include "types.h"

extern u8 eScenarioEffectState2000780[];

// Returns &eScenarioEffectState2000780[0x18] (address, not the value).
u8 *sub_81421D8_c(void)
{
    return &eScenarioEffectState2000780[0x18];
}
