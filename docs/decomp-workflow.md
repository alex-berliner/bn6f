# Decomp workflow

Audience: someone converting an ASM function to C in this repo.

## TL;DR

1. Pick a function from `issues/decomp-blockers.md` or the open decomp
   candidate list. Smallest functions first.
2. Add ASM-side `.ifndef DECOMP_<sym>` gate (see [ASM gating](#asm-gating)).
3. Write the C reimpl in `src/c/<snake_case>.c`. Match orig behavior
   exactly — read the original ASM as the source of truth.
4. **Grep `.word <sym>+1` in `asm/` before adding to manifest.** Any hit
   means the caller uses the indirect `mov lr, pc; bx rN` pattern and
   the C version must use `DECOMP_VTABLE_WRAPPER` (see [Wrapper macros](#wrapper-macros)).
5. Add the symbol to `tools/decomp_manifest.txt`.
6. Validate: `bn6f-validate run --patch <Sym>` — per-frame pixel-hash
   of the patched ROM vs orig across the bk2 fixtures.
7. If it fails, recheck PAD, wrapper macro, and arg/return types
   (see [Common pitfalls](#common-pitfalls)).

## ASM gating

Every convertible ASM function gets wrapped in:

```asm
.ifndef DECOMP_FooBar
    thumb_func_start FooBar
FooBar:
    < original body, untouched >
    thumb_func_end FooBar
.else
    thumb_func_start FooBar
FooBar:
    decomp_trampoline FooBar_c, <PAD>
    thumb_func_end FooBar
.endif
```

The `decomp_trampoline` macro (in `include/macros/function.inc`) emits
`ldr r3, =FooBar_c+1; bx r3; .pool` (8 bytes) followed by `<PAD>` bytes
of `nop` so the trampoline occupies the same slot the orig function
did. **`PAD` must equal `orig_body_size - 8`** (or `- 10` if the
function starts at a 2-aligned-but-not-4-aligned address, because
`.pool` inserts a 2-byte alignment pad).

Get the orig size via `arm-none-eabi-nm --numeric-sort build/bn6f_orig.elf`
and subtract the next symbol's address.

## C reimplementation rules

In `src/c/foo_bar.c`:

```c
#include "types.h"

void FooBar_c(u32 a0, u32 a1, u32 a2)
{
    // body
}
```

Argument types follow AAPCS: r0=arg0, r1=arg1, r2=arg2, r3=arg3, then
stack. Return value goes in r0. agbcc compiles with `-mthumb-interwork`,
so the prologue/epilogue handle thumb ↔ ARM mode automatically — but
see [LR-bit-bx hazard](#lr-bit-bx-hazard).

**Don't** add error handling, bounds checks, or validation that the
orig didn't do. The validator checks behavior matches exactly — extra
defensive code will fail in subtle ways (e.g., orig overflows by
design and the game depends on the wrap).

**Don't** use libc. agbcc links `tools/agbcc/lib/libgcc.a` for compiler
helpers (`__divsi3` etc.) but nothing else. No `malloc`, no `memcpy`
— write the loop.

**Comments**: lead with the orig ASM body. Future you needs to verify
the C still matches. Don't paraphrase — paste the actual lines.

```c
// Original ASM:
//   ldr r0, =eFoo
//   ldrb r0, [r0]
//   mov pc, lr
u8 eFoo_get_c(void) { return eFoo; }
```

## Wrapper macros

Three macros live in `src/c/types.h`. Pick based on how the caller
invokes the function.

### `DECOMP_VTABLE_WRAPPER(WRAPPER, IMPL)`

Use when **any** caller invokes the symbol via a function pointer:
`ldr rN, =FooBar+1; mov lr, pc; bx rN` or
`ldr rN, [jump_table]; mov lr, pc; bx rN`.

Such a caller writes `lr` from `mov lr, pc` where `pc` is read with
bit 0 = 0 (thumb register-read convention). Orig ASM returns via
`pop {pc}` / `mov pc, lr` which preserves the current mode regardless
of lr bit 0. agbcc-compiled C ends with `pop {rN}; bx rN`, which
**interworks on bit 0** → switches the caller back to ARM mode →
the caller's next thumb instruction is decoded as a different ARM
instruction → silent corruption.

```c
static void FooBar_impl(u32 arg) { /* body */ }
DECOMP_VTABLE_WRAPPER(FooBar_c, FooBar_impl)
```

The macro emits a naked function ending in `mov pc, rN`, so the
return preserves the caller's mode regardless of lr bit 0.

**How to detect the need**: `grep '\.word <sym>+1' asm/*.s`. Any hit
= use the wrapper. `bl <sym>` callers are safe with a plain C function
(`bl` writes LR with bit 0 = 1).

### `DECOMP_FLAG_WRAPPER(WRAPPER, IMPL)`

Use when a caller does `bl <sym>; beq/bne ...` and the orig function's
last instruction is something that updates flags (`cmp`, `tst`,
`subs`, etc.) — i.e., the caller reads the Z/N/C/V flags after the
call. A plain C return doesn't set flags from the return value.

```c
static u8 isFooActive_impl(void) {
    return eFoo & 1;
}
DECOMP_FLAG_WRAPPER(isFooActive_c, isFooActive_impl)
```

The macro emits `bl IMPL; tst r0, r0; pop {pc}` so Z reflects the
return value.

### `__attribute__((naked))` (manual)

If neither pattern fits — e.g. the function takes 4 args and the C
prologue's push would clobber r3 before stashing it — write a custom
naked wrapper. See `src/c/spawn_ow_player_object.c` for an example
that saves r4 across the call and restores from the stack.

## Multi-entry-point functions

Some ASM functions have two `thumb_func_start` labels sharing a body:

```asm
sub_FOO:
    mov r0, #0
    b sub_FOO_common
sub_FOO_alt:
    mov r0, #4
sub_FOO_common:
    < shared body >
```

Only `sub_FOO_common` is the actual body. The `.ifndef DECOMP_sub_FOO`
should wrap **only the common label's body**, not the prelude. See
`asm/asm03_0.s::sub_802FDB0` for a canonical example. The C function
takes the entry-selector as r0 and dispatches internally.

`PAD` calculation accounts for the prelude staying in place — measure
from the common label, not the function entry.

## Manifest entry

Add the symbol to `tools/decomp_manifest.txt`:

```
ByteFill
CallBGScrollCallback0
...
FooBar
```

One symbol per line, no leading/trailing whitespace. Comments allowed
(`#` at line start). The order doesn't matter; `make decompile` reads
the whole file at config time.

## Validating

Validation is a single check: does the patched ROM render the same
pixels as orig, every frame, on every bk2 fixture?

```
# build the validator once
(cd tools/bn6f-validate && cargo build --release)

# validate just the function you added
bn6f-validate run --patch FooBar

# validate everything (orig vs each patch, parallel)
bn6f-validate run -j 8
```

`run` builds the orig + per-patch ROMs, replays each `.bk2` in
`tests/fixtures/demos/bk2/` through both under libmgba, SHA256-hashes
the visible framebuffer per frame, and diffs the hash streams. A patch
passes only if its hash stream is byte-identical to orig's on every
fixture. Results land in `build/validate_results.csv`:

```
rom_stem,bk2,verdict,first_diff_frame
0000007_FooBar,intro,pass,
0000007_FooBar,coldboot,pass,
0000008_BazQux,intro,fail,279
```

A `fail` with a `first_diff_frame` is the trigger to debug: that frame
is where the patched ROM first diverged from orig. Render both to mp4
for a visual look with `bn6f-validate run --patch BazQux --videos`
(review only — the hashes are the correctness signal), then fix or
revert that conversion.

See [../tools/bn6f-validate/README.md](../tools/bn6f-validate/README.md)
for the `hash` / `video` / `both` / `compare` subcommands used to drill
into a single (ROM × bk2) pass.

## When validation is green

Commit with a clear message. The conventional format in this repo:

```
Convert N more leaves (category / category)

- FooBar (0x08000920)
- BazQux (0x08000A3C)

Co-Authored-By: ...
```

## Common pitfalls

| Symptom | Likely cause |
|---|---|
| `make decompile` fails with `cannot find ewram.o` | linker script path drift; run from repo root |
| validate fails from frame 0 on every fixture | trampoline size mismatch (recheck PAD), or LR-bit-bx (needs `DECOMP_VTABLE_WRAPPER`) |
| validate fails mid-run on one fixture | behavioural bug in the C body; `first_diff_frame` localises it |
| validate passes but ROM misbehaves interactively | exercise a longer fixture; possible mode flip in an untracked caller |
| ROM size > 16 MB | C functions overflowed `.c_code`; bump LENGTH in `ld_script_decompile.ld` |

## Where to look in the source

| File | Purpose |
|---|---|
| `tools/decomp_manifest.txt` | conversion list |
| `tools/function_symbols.txt` | generated address ↔ name map |
| `include/macros/function.inc` | `decomp_trampoline` ASM macro |
| `src/c/types.h` | `DECOMP_*_WRAPPER` macros |
| `ld_script.ld` | sha-matched build linker script |
| `ld_script_decompile.ld` | decomp build linker script (`.c_code` section) |
| `issues/decomp-blockers.md` | open blockers preventing larger fn decomp |
| `issues/concerns/` | reference docs for ABI, timing, IRQ, etc. |

---
_Last updated: 2026-05-29 12:48:16 -0400_
