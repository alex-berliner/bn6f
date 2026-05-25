#include "types.h"

extern u8 sub_800A7E2(void);
extern void *battle_findPlayer(u8 alliance);

// Returns battle_findPlayer of the alliance currently held at
// Toolkit.BattleStatePtr->Unk_0d (which sub_800A7E2 reads via r10).
void *sub_80103EC_c(void)
{
    return battle_findPlayer(sub_800A7E2());
}
