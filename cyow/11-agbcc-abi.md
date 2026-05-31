# 11 — agbcc toolchain / ABI constraint

Not a tool — the ground rule the decomp obeys. `agbcc` (the pret/old-GCC
GBA compiler, built from `tools/agbcc-src` → `tools/agbcc/bin/agbcc`)
compiles the C: `.c` → cpp → agbcc → binutils `as`, at
`-O2 -mthumb-interwork`.

## Why agbcc (the constraint, narrowed)

The SHA-exact build (`make all`) is **ASM-only** — agbcc runs only in
`make decompile`. So agbcc does NOT protect byte-matching; it protects
**runtime ABI compatibility at the ASM↔C boundary**. Converted C must
honor the contract the immovable surrounding ASM assumes: register usage,
struct/64-bit passing, and the game's non-standard conventions
(flag-on-return, ambient registers). agbcc is privileged only by being the
*incumbent* — the compiler lineage that produced the ROM — not by being
"good". Most of the ROM is compiler output anyway (see
[origin-classification](origin-classification.md): ~96% generated).

## Sub-finding: the r10 ambient pointer + clobber fragility

The game keeps a global base pointer in **r10** (the "Toolkit" pointer;
r5 = sprite/chatbox). Verified by frequency: r10 is **read 1459×, written
82×** (~18:1) — a held-live global, not a scratch register. It's not
hand-written ASM and not a plain memory `extern`; it's a **register-pinned
global** (a global-register-variable convention the original toolchain
used).

**Current handling is fragile.** Every ambient-reader C file does a
per-function capture hack:
```c
register u8 *r10p asm("r10");
asm volatile("" : "=r"(r10p));
x = *(u8 **)(r10p + 0x14);
```
and `CCFLAGS` has **no `-ffixed-r10`**, so agbcc may allocate r10 as
scratch. The capture-at-entry bets the compiler doesn't touch r10 first.

**Verified fix direction — file-scope global register variable.** agbcc
supports both `register T *g asm("r10")` (emits `mov rN, sl`) and
`-ffixed-r10` (accepted). Prototype on `sub_8005F28` (real agbcc, real
pipeline):

| | emitted body |
|---|---|
| current hack | `mov r3,sl; push{r3}; mov r0,sl; add r0,#20; ldr r0,[r0]; ldrb r0,[r0,#16]; pop{r3}; mov sl,r3; bx lr` |
| global reg var | `mov r0,sl; add r0,#20; ldr r0,[r0]; ldrb r0,[r0,#16]; bx lr` |
| original ASM | `mov r0,r10; ldr r0,[r0,#0x14]; ldrb r1,[r0,#0x10]; cmp r1,#0; mov pc,lr` |

The hack forces a **spurious r10 save/restore** (+4 instrs); the global
register variable is clean, structurally the original, and removes the
clobber-fragility class outright. It also unlocks typed accesses
([[feedback_typed_struct_accesses]]): `gToolkit->Warp2011bb0_Ptr` instead
of `*(u8**)(r10p+0x14)`.

**Scope it per-file, not blanket `-ffixed-r10`.** The original uses r10 as
scratch in ~82 sites; a global `-ffixed-r10` would diverge from the
original there. A file-scope global register variable reserves r10 only in
the ambient-reader files, leaving scratch-using functions free. Conflict
only if one function both reads ambient r10 and (in the original) used it
as scratch — rare, handle by hand.

**Not yet proven byte-identical.** The GRV prototype still differs from the
original in offset folding (`add r0,#20; ldr` vs `ldr r0,[r0,#0x14]`) and
return style (`bx lr` vs `mov pc,lr`) — separate agbcc codegen items, not
the r10 question. Full `make decompile` + validate needed to confirm a
match.

## The three strategic options (from discussion)

The constraint is **per-location** — it only binds where immovable ASM
calls the code. So the choice tracks relocation:
1. **Extend agbcc** (e.g. mode-preserving epilogue) — kills a wrapper
   class at the source; invests in a dead compiler. Narrow tactical play;
   gated on the Feature 3 demonstrator.
2. **Wrappers** (status quo) — the transitional bridge, kept regardless;
   permanent scaffolding tax, wrong as a destination.
3. **Modern compiler + extensions** — can't break matching (ASM-only
   build), likely erases the VTABLE/LR-bit class via correct interworking,
   aligns with the relocatable/moddable end goal. Cost: boundary ABI
   bridging during transition, which shrinks as the ASM boundary shrinks.

Relocation is where agbcc's privilege dissolves: a relocated cluster's
interior is C↔C, so it can be modern-C with only its edge bridged.

## Verdict

_pending_ — leaning: option 3 as direction (modern compiler for relocated
clusters), wrappers as the transitional bridge, option 1 only if the
Feature 3 demonstrator proves a wrapper class dies cheaply. Adopt the
file-scope global register variable for r10/r5 regardless — it's a strict
improvement under the current agbcc too.

---
_Last updated: 2026-05-31 11:29:37 -0400_
