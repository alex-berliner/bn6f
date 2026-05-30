#include "types.h"

/* === DELIBERATELY BROKEN ByteFill ===
 *
 * This is the canary used by tests/harness/canary.sh to verify that
 * bn6f-validate actually detects failures. We XOR the byte value
 * before writing — a 1-bit shift in every filled byte. Anywhere
 * ByteFill writes to a buffer the game later reads or renders, the
 * frames must diverge from orig.
 *
 * If bn6f-validate run --patch ByteFill against this corrupted source
 * still reports PASS, the harness is broken and the canary fails.
 */
void ByteFill_c(u8 *dst, u32 count, u8 byte)
{
    while (count-- > 0) {
        dst[count] = byte ^ 0x01;   /* canary divergence */
    }
}
