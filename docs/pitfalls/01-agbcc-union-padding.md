# 01 — agbcc union / small-struct +4-byte padding

**Class:** build-system / C codegen
**Severity:** silent miscompilation (wrong field offsets at runtime)
**Status:** workaround established; structural fix in issues #11

## Symptom

A C port accesses a struct field by name (`eToolkit->BattleStatePtr->Unk_32`)
and the generated thumb code reads from the wrong byte offset — typically
the field's *expected* offset plus a small multiple of 2 bytes. Game
state diverges from orig because the wrong memory location is being
read/written. The divergence is usually small (1-2 bytes) but real.

First seen with `battle_setFlags_c` / `battle_clearFlags_c`. Both
referenced `eToolkit->BattleStatePtr->Unk_32` (expected offset 0x32),
but the compiled `ldrh` accessed offset 0x3a (8 bytes too far).

## Why

agbcc (gcc 2.9-arm-000512) gives every C `union` and every `struct`
with sizeof < 4 a **minimum size of 4 bytes and 4-byte alignment**,
regardless of what the language standard says. Standard C would
align a union/struct to its strictest member's alignment (2 bytes
for a union containing u16).

The auto-generated headers in `constants/headers/structs/*.h`
(emitted by `tools/struct_inc_to_h.py`) faithfully emit a C union
wherever the `.inc` source has a `union / nextu / endu` block —
typically used for "this field can be read as `u8/u8` or as `u16`."
Each such union adds +2 bytes of unexpected padding in agbcc's
layout, and every later field in the struct shifts by that amount.

`BattleState` has 3 unions before offset 0x32:
- `_union_0x2` (u8/u8 vs u16) at expected 0x02 → agbcc places at 0x04
- `_union_0x4` (u8/u8 vs u16) at expected 0x04 → agbcc places at 0x08
- `_union_0x12` (u8/u8 vs u16) at expected 0x12 → agbcc places at 0x18

Cumulative shift by the time we reach `Unk_32`: +8 bytes. agbcc
places `Unk_32` at offset 0x3a (decimal 58) instead of 0x32 (decimal 50).

Verified empirically via an `offsetof` probe:

```c
u32 off_u32(void) { return (u32)&((BattleState *)0)->Unk_32; }
```

Compiled with agbcc emits `mov r0, #58` — confirming the bug.

## How to detect

If a C port that looks semantically equivalent to its orig ASM still
diverges in lockstep / last-frame check, disassemble the generated
function and check the load/store offsets:

```sh
addr=$(arm-none-eabi-nm build/bn6f.elf | grep " T fn_name_c$" | awk '{print $1}')
arm-none-eabi-objdump -d build/bn6f.elf --start-address=0x$addr --stop-address=$(printf "0x%x" $((0x$addr + 0x40)))
```

Compare the `ldrb / ldrh / ldr / strb / strh / str` immediate offsets
against what the orig ASM uses (look for `o<Struct>_<Field>` symbols).
If they differ, you've hit this bug.

To confirm with a quick probe, write a function that returns the
offset:

```c
u32 off_field(void) { return (u32)&((StructName *)0)->FieldName; }
```

Compile with agbcc and check the `mov r0, #N` value.

## Affected structs

Any struct in `constants/headers/structs/` whose `.inc` source contains
`union ... nextu ... endu`. Known examples:

- `BattleState` (3 unions before 0x32 → +8 byte shift on fields 0x18+)
- `RenderInfo` (has `_union_0x2`)
- `CutsceneCameraInfo` (has `_union_0x4`)
- `CollisionData` (has `_union_0x4`)
- `OWObjectInteractionArea` (has `_union_0x4`)
- `BattleObjectsLinkedListSentinel` (has `_union_0x22`, `_union_0x24`, `_union_0x2C`)
- `OverworldNPCObject` (has `_union_0x40`)

`Toolkit` itself has NO unions, so `eToolkit->FieldPtr` always works
correctly. The bug bites only when you dereference into one of the
affected pointee types.

## Fix (per-function workaround)

Bypass the broken struct layout by computing the byte offset
explicitly:

```c
/* Don't do this — wrong offset under agbcc: */
eToolkit->BattleStatePtr->Unk_32 |= (u16)mask;

/* Do this — explicit byte offset: */
u16 *p = (u16 *)((u8 *)eToolkit->BattleStatePtr + 0x32);
*p |= (u16)mask;
```

`battle_getFlags_c` uses this pattern already; it's been the
convention since before the bug was understood.

For multi-field access, helper macros help:

```c
#define BSTATE(p, off, type) (*(type *)((u8 *)(p) + (off)))
BSTATE(eToolkit->BattleStatePtr, 0x32, u16) |= mask;
```

## Fix (structural)

Issues #11: change `tools/struct_inc_to_h.py` to emit `u8` byte arrays
spanning the union range, plus accessor macros for the named
alternates:

```c
/* instead of: */
union { struct { u8 Unk_02; u8 Unk_03; } _u0; ... } _union_0x2;

/* emit: */
u8 _bytes_0x2[2];
#define StructName_Unk_02(p)    (((u8 *)(p))[0x02])
#define StructName_Unk_02_03(p) (*(u16 *)((u8 *)(p) + 0x02))
```

Estimated half-day effort; unblocks straightforward struct access
across ~10% of decomp candidates.

## Related

- `issues/decomp-blockers.md` #11
- `issues/decomp-blockers.md` #8 (typed struct accesses generally)
- `src/c/battle_set_clear_flags.c` (per-function workaround example)
- `src/c/battle_get_flags.c` (predates fix, already uses raw offsets)
