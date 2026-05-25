#include "types.h"

extern u8 eScenarioEffectState2000780[];

u32 Is_eScenarioEffectState2000780_Initialized_impl(void)
{
    return eScenarioEffectState2000780[0];
}

DECOMP_FLAG_WRAPPER(Is_eScenarioEffectState2000780_Initialized_c,
                    Is_eScenarioEffectState2000780_Initialized_impl)
