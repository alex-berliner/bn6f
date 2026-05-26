#include "types.h"

extern u8 unk_200F388[];
extern void ZeroFillByEightWords_c(u32 *dst, u32 byte_count);
extern void ZeroFillByByte_c(u8 *dst, u32 byte_count);
extern void copy_8002668(void);
extern void InitializeOWPlayerObjectStruct(void);
extern void InitializeOverworldNPCObjectStructs(void);
extern void InitializeOverworldMapObjectStructs(void);
extern void sprite_resetObjVars_800289C(void);

// Per-map-load OAM/VRAM zero + object struct initialisation pipeline.
//   OAM (0x07000000):       zero 0x400 bytes
//   VRAM[1] (0x06010000):   zero 0x8000 bytes
//   plus a chain of struct-init helpers
//   finally zero 7 bytes of unk_200F388
void copy_800260C_c(void)
{
    ZeroFillByEightWords_c((u32 *)0x07000000, 0x400);
    ZeroFillByEightWords_c((u32 *)0x06010000, 0x8000);
    copy_8002668();
    InitializeOWPlayerObjectStruct();
    InitializeOverworldNPCObjectStructs();
    InitializeOverworldMapObjectStructs();
    sprite_resetObjVars_800289C();
    ZeroFillByByte_c(unk_200F388, 7);
}
