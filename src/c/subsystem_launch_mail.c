#include "types.h"

extern void sub_8127990(void);
extern void SetScreenFade(s32 a, s32 b);

// Triggers the "mail" subsystem launch sequence:
//   1. sub_8127990 (mail-specific setup)
//   2. Capture current OW player coords + facing into GameState
//   3. Set GameState.SubsystemIndex = 0x34 (mail)
//   4. SetScreenFade(0xc, 0x10) to fade out
// Returns 0.
u32 subsystem_launchMail_c(void)
{
    register u8 *r10p asm("r10");
    u8 *gs;
    u8 *ow;
    asm volatile("" : "=r"(r10p));

    sub_8127990();
    gs = *(u8 **)(r10p + 0x3c);      // Toolkit.GameStatePtr
    ow = *(u8 **)(gs + 0x18);        // GameState.OverworldPlayerObjectPtr

    *(u32 *)(gs + 0x24) = *(u32 *)(ow + 0x1c);  // PlayerX = ow.X
    *(u32 *)(gs + 0x28) = *(u32 *)(ow + 0x20);  // PlayerY = ow.Y
    *(u32 *)(gs + 0x2c) = *(u32 *)(ow + 0x24);  // PlayerZ = ow.Z
    *(u32 *)(gs + 0x30) = ow[0x10];             // FacingDirectionAfterWarp = ow.Facing
    gs[0] = 0x34;                                // SubsystemIndex = mail

    SetScreenFade(0xc, 0x10);
    return 0;
}
