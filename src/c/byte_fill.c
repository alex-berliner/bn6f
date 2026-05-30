#include "types.h"

/* ByteFill — fill `count` bytes at `dst` with `byte`.
 *
 * Original ASM (asm/asm00_0.s):
 *   ByteFill:
 *     sub  r1, #1          // count -= 1
 *     strb r2, [r0,r1]     // dst[count] = byte
 *     bne  ByteFill        // loop while count != 0
 *     mov  pc, lr
 * r0=dst, r1=count, r2=byte. Fills high index to low.
 *
 * (The deliberately-broken XOR variant used by the harness self-test
 * lives in byte_fill_canary.c — NOT here.)
 */
void ByteFill_c(u8 *dst, u32 count, u8 byte)
{
    while (count-- > 0) {
        dst[count] = byte;
    }
}
