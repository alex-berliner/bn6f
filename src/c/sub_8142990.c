#include "types.h"

extern void ReadOWPlayerObjectCoords(void);
extern void sub_8142816(void);

// Thin wrapper: ReadOWPlayerObjectCoords(); sub_8142816();
void sub_8142990_c(void)
{
    ReadOWPlayerObjectCoords();
    sub_8142816();
}
