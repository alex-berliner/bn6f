#include "types.h"

extern u8 byte_203F4A4[];
extern u8 byte_20349C0[];
extern u8 byte_203F5A4[];
extern u8 byte_2034A10[];
extern u8 byte_203F4F4[];
extern u8 eBattleNaviStats0[];
extern u8 byte_203F5F4[];
extern u8 eBattleNaviStats1[];
extern void CopyWords(const void *src, void *dst, u32 byte_count);
extern u32 GetBattleEffects(void);

// Transfer the "hand" navi-stats blocks from the staging area
// (byte_203F4F4 / byte_203F5F4 + adjacent buffers) into the
// canonical eBattleNaviStats slots for this battle. The 0x50-byte
// scratch copies are skipped when the source sentinel byte is 0xff
// (no live data). The two "Alliance 1" branches are gated by
// (BattleEffects & 8) — the second-alliance battle flag.
//
// Original semantics preserved exactly: GetBattleEffects is called
// twice (once before each Alliance-1 gate), not cached.
void transferBattleHandNaviStats_800B3D8_c(void)
{
    if (byte_203F4A4[0] != 0xff) {
        CopyWords(byte_203F4A4, byte_20349C0, 0x50);
    }
    if (GetBattleEffects() & 8) {
        if (byte_203F5A4[0] != 0xff) {
            CopyWords(byte_203F5A4, byte_2034A10, 0x50);
        }
    }
    CopyWords(byte_203F4F4, eBattleNaviStats0, 0x64);
    if (GetBattleEffects() & 8) {
        CopyWords(byte_203F5F4, eBattleNaviStats1, 0x64);
    }
}
