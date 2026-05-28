#include "EWRAM.h"

/* These read/write `eToolkit->BattleStatePtr->Unk_32` (a u16 at the
 * BattleState struct's 0x32 byte offset). We can't use the typed
 * field accessor `->Unk_32` here because agbcc lays out BattleState
 * with 8 bytes of extra padding — three unions earlier in the struct
 * each get bumped to 4-byte size/alignment by agbcc (instead of 2),
 * shifting every field at and after offset 0x18 by +8.
 *
 * battle_getFlags_c uses this raw-offset pattern for the same field.
 * Same workaround applies here. Root cause and the deeper fix (don't
 * emit C unions from tools/struct_inc_to_h.py) tracked in
 * issues/decomp-blockers.md.
 */
#define BATTLESTATE_UNK_32 0x32

void battle_setFlags_c(u32 mask)
{
    u16 *p = (u16 *)((u8 *)eToolkit->BattleStatePtr + BATTLESTATE_UNK_32);
    *p |= (u16)mask;
}

void battle_clearFlags_c(u32 mask)
{
    u16 *p = (u16 *)((u8 *)eToolkit->BattleStatePtr + BATTLESTATE_UNK_32);
    *p &= (u16)~mask;
}
