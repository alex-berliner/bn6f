#include "types.h"

/* === Harness mutation canary === *
 *
 * Deliberately-broken ByteFill used by tests/harness/canary.sh to
 * verify that bn6f-validate detects a real divergence. XORs every
 * written byte with 0x01 — anywhere ByteFill writes to a buffer the
 * game later reads or renders, frames must diverge from orig.
 *
 * Activated by --patch ByteFillCanary, which sets DECOMP_ByteFillCanary
 * and triggers the canary trampoline in asm/asm00_0.s. Lives at canary
 * patch index 7000001 (see CANARY_PATCHES in tools/bn6f-validate/src/
 * orchestrate.rs) so its build artifacts (ROM / hashes / videos) never
 * collide with the real ByteFill patch at index 1.
 */
void ByteFillCanary_c(u8 *dst, u32 count, u8 byte)
{
    while (count-- > 0) {
        dst[count] = byte ^ 0x01;
    }
}
