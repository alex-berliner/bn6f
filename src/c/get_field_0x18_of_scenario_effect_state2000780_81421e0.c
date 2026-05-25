#include "types.h"

extern u8 eScenarioEffectState2000780[];

// Returns *(u32 *)&eScenarioEffectState2000780[0x18] (word_2000798).
u32 getField0x18OfScenarioEffectState2000780_81421e0_c(void)
{
    return *(u32 *)&eScenarioEffectState2000780[0x18];
}
