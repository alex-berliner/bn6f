# 04 — gcc r10 save/restore around bl calls

**Class:** build-system / C codegen
**Severity:** cycle overhead, contributes to drift
**Status:** workaround established (use absolute `eToolkit`)

## Symptom

A C port that reads r10 (the project-wide Toolkit pointer convention)
via the inline-asm register pattern compiles to *more* code than
expected. Every `bl` to another function is bracketed with
`mov r3, sl; push {r3}; ...; pop {r3}; mov sl, r3` — an extra ~4
instructions / ~8 cycles per call.

Visible in disassembly:

```
push {lr}
mov r3, sl       @ r3 = r10
push {r3}        @ save r10 to stack
mov r0, sl       @ ... use r10 ...
adds r0, #60
ldr r0, [r0, #0]
...
bl other_fn
pop {r3}         @ restore r10 from stack
mov sl, r3
pop {r0}
bx r0
```

## Why

The convention in this project is that **r10 is a "global" register**
holding the Toolkit pointer at all times. The ASM never saves/restores
it across calls — every function trusts r10 is intact.

When a C port wants to read r10, the typical pattern is:

```c
register u8 *r10p asm("r10");
u8 *gs;
asm volatile("" : "=r"(r10p));
gs = *(u8 **)(r10p + 0x3C);
```

gcc's view of this:

- `register u8 *r10p asm("r10")` reserves r10 for the variable
- The inline-asm output constraint `"=r"(r10p)` tells gcc the variable
  is written by the asm
- BUT gcc still treats r10 as **caller-saved** in its general ABI
  model — across any function call, gcc believes r10 might be
  clobbered
- So gcc inserts save/restore around every `bl` to preserve `r10p`'s
  value

This is conservative but wrong for our convention: r10 is *globally*
preserved by every project function, so the save/restore is
unnecessary work.

The cost adds up: ~8 cycles per `bl` call, every call site that reads
r10. On hot paths this contributes to trampoline cycle drift (pitfall
02) by making the function take longer.

## Fix

When the C port only needs to **read** r10 (the typical case), use
the absolute address constant instead of the register pattern:

```c
#include "EWRAM.h"   // defines eToolkit = (Toolkit *)0x020093B0

void fn_c(void) {
    u8 *gs = (u8 *)eToolkit->GameStatePtr;   // ldr from literal pool
    ...
}
```

agbcc compiles this to:

```
push {lr}
ldr r0, [pc, #N]    @ r0 = 0x020093b0
ldr r0, [r0, #60]   @ r0 = *(0x020093b0 + 0x3c) = GameStatePtr
...
bl other_fn         @ NO save/restore needed
pop {r0}
bx r0
```

Cleaner codegen, no spurious save/restore, and fewer cycles.

## When NOT to use this fix

If the function needs to *write* r10 (rare — would be modifying
the global Toolkit pointer), you have to use the register pattern.
But almost no project function does this.

## Why the savings matter

This pitfall is one of the contributing causes to trampoline cycle
drift (pitfall 02). Removing 8 cycles per `bl` from a function that's
called heavily on a tight frame can close the gap between
mainline-finishes-in-time vs mainline-misses-VBlank.

It alone doesn't always fix drift-class divergences, but combined
with other optimizations it can move a patch from drift-fail to drift-pass.

## Related

- `src/c/cutscene_camera_focus_camera_on_player_maybe_8036faa.c`
  (changed mid-iteration from register-pattern to absolute eToolkit;
  the change shifted divergence but didn't fully fix — see issues #12)
- `constants/headers/EWRAM.h` (eToolkit definition)
- `docs/pitfalls/02-trampoline-cycle-drift.md`
