# src/c/

C reimplementations of ASM functions listed in
`tools/decomp_manifest.txt`. Compiled by agbcc (gcc 2.95-derived) with
`-O2 -mthumb-interwork` into `build/c/<file>.o`, linked into the
`.c_code` section of the decomp ROM.

See [docs/decomp-workflow.md](../../docs/decomp-workflow.md) for the
end-to-end "convert this ASM function" guide.

## Conventions

### File naming

One `.c` per converted ASM symbol. Filename is `<snake_case>.c` derived
from the ASM symbol:

| ASM symbol | C file |
|---|---|
| `CopyWords` | `copy_words.c` |
| `eStruct200BC30_getJumpOffset00` | `estruct200bc30_get_jump_offset00.c` |
| `sub_802FDB0` | `sub_802fdb0.c` |
| `IsScreenFadeActive` | `is_screen_fade_active.c` |

The `bk2_extract.py` script and other tools don't care; agbcc's only
constraint is one `.text` section per `.c`.

### Function naming

The exported symbol is the original ASM name with `_c` suffix:

```c
void CopyWords_c(const u32 *src, u32 *dst, u32 byte_count) { ... }
```

The ASM trampoline jumps to `CopyWords_c+1` (thumb bit). The `+1`
suffix is essential — without it the linker resolves to ARM mode and
the trampoline switches modes incorrectly.

If you wrap the C body with `DECOMP_*_WRAPPER` (see below), the
implementation goes in a `static <fn>_impl` and the macro generates
the `_c` exported symbol.

### Includes

```c
#include "types.h"
```

`types.h` defines `u8/u16/u32/s8/s16/s32/bool8` plus the
`DECOMP_FLAG_WRAPPER` and `DECOMP_VTABLE_WRAPPER` macros. Almost
everything else is global symbols declared `extern` in your `.c`:

```c
extern u32 eFooStruct;
extern u8 byte_200AC1C;
```

For struct accesses, see `decomp_structs.h` (still being built out —
some files use raw offsets, some use typed accesses; the migration is
documented in the `feedback_typed_struct_accesses` memory).

### Comments

Lead every function with the orig ASM body in a comment so a future
reader (or you, after a break) can verify the C still matches without
opening another file:

```c
// Original ASM:
//   ldr r1, =eFoo
//   ldrb r0, [r1]
//   mov pc, lr
u8 getFoo_c(void) { return eFoo; }
```

For longer functions paste the ASM verbatim. Don't paraphrase.

## Wrapper macros

Three macros in `types.h`. Pick by the calling convention used by the
function's callers in ASM. Wrong macro = silent failure (validation
might pass but ROM corrupts state).

### `DECOMP_VTABLE_WRAPPER(WRAPPER, IMPL)`

For functions reachable via `mov lr, pc; bx rN` (any data-table
function pointer entry, vtable, ToolkitExtraPtrs, etc.). Generates a
naked function ending in `mov pc, rN` so the caller's mode bit is
preserved across the return.

```c
static void Foo_impl(u32 a) { ... }
DECOMP_VTABLE_WRAPPER(Foo_c, Foo_impl)
```

Detect with `grep '\.word <sym>+1' asm/*.s` — any hit means use this
macro. See `decomp_lr_bit_bx_bug` memory for the full bug write-up.

### `DECOMP_FLAG_WRAPPER(WRAPPER, IMPL)`

For functions whose callers do `bl <fn>; beq/bne ...` and the orig
ASM left flags set from a final `cmp`/`subs`/`tst`. The macro adds
`tst r0, r0` after calling IMPL so Z reflects the return value.

```c
static u8 isActive_impl(void) { return state & 1; }
DECOMP_FLAG_WRAPPER(isActive_c, isActive_impl)
```

### Custom `__attribute__((naked))`

When neither macro fits — e.g. the function takes 4 args and a normal
push would clobber r3 before stashing it — write a custom naked
wrapper. See `src/c/spawn_ow_player_object.c` for a worked example.

## What to avoid

- **libc functions.** agbcc only links libgcc. Write the loop.
- **Defensive code.** No bounds checks the orig didn't do. The
  validator catches behavioral divergence; extra "safety" fails it.
- **Comments that describe what the code does.** Names already do
  that. Comments here explain *why this isn't the same as orig* (e.g.
  a subtle ABI detail) or *what bug class triggered the wrapper*.
- **Cross-file dependencies between C functions.** Each file is a
  unit. Use `extern` declarations for ASM-side symbols, never include
  another `.c`.

## Validating

```
# build once, then validate the patch you added
(cd tools/bn6f-validate && cargo build --release)
bn6f-validate run --patch FooBar
```

`bn6f-validate run` per-frame pixel-hashes the patched ROM against orig
across every bk2 fixture; a byte-identical hash stream means the C
matches. See
[docs/decomp-workflow.md](../../docs/decomp-workflow.md#validating) and
[tools/bn6f-validate/README.md](../../tools/bn6f-validate/README.md).

When validation is green, commit. When it fails, the `first_diff_frame`
in `build/validate_results.csv` localises the divergence — recheck PAD,
the wrapper macro, and arg/return types.

---
_Last updated: 2026-05-29 12:48:44 -0400_
