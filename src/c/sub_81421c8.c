#include "types.h"

extern u8 eScenarioEffectState2000780[];

// eScenarioEffectState2000780[0xb] = (u8)val (byte_200078B).
void sub_81421C8_c(u8 val)
{
    eScenarioEffectState2000780[0xb] = val;
}
