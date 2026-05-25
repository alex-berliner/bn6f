#include "types.h"

extern u8 byte_812DA94[];
extern void sub_80465A0(void *a1);

// Thin wrapper: sub_80465A0(&byte_812DA94).
void sub_812EB78_c(void)
{
    sub_80465A0(byte_812DA94);
}
