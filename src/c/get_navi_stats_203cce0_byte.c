#include "types.h"

extern u8 *GetNaviStats203CCE0Addr(u32 idx);

// Returns NaviStats203CCE0(0)[off] as u8.
u8 GetNaviStats203CCE0Byte_c(u32 _unused, u32 off)
{
    (void)_unused;
    return GetNaviStats203CCE0Addr(0)[off];
}
