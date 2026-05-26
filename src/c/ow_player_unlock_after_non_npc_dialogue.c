#include "EWRAM.h"

extern void SetPlayerCanMoveEventFlag_c(void);
extern void ClearEventFlag_c(u32 flag);

/* Unlock OWPlayer after a non-NPC dialogue: clear the +0 byte of
   the OWPlayer block, set the "can move" event flag, then clear
   EVENT 0x1719 (FromImmediate 23,25). */
static void owPlayer_unlockPlayerAfterNonNPCDialogue_809E122_impl(void)
{
    *(u8 *) 0x0200ACE0u = 0;
    SetPlayerCanMoveEventFlag_c();
    ClearEventFlag_c(0x1719u);
}

DECOMP_VTABLE_WRAPPER(owPlayer_unlockPlayerAfterNonNPCDialogue_809E122_c, owPlayer_unlockPlayerAfterNonNPCDialogue_809E122_impl)
