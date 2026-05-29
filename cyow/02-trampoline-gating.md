# 02 — ASM gating + `decomp_trampoline` (the staging mechanism)

## What it is

The core trick that lets a C reimplementation stand in for an ASM
function **without** moving the function or breaking the SHA-matched
build. Every convertible function is wrapped in a preprocessor gate;
the decomp build swaps the body for an 8-byte branch into C.

## How it works today

Each gated function in `asm/*.s` (real `ByteFill` example):

```asm
.ifndef DECOMP_ByteFill
    thumb_func_start ByteFill
ByteFill:
    < original body, untouched >
    thumb_func_end ByteFill
.else
    thumb_func_start ByteFill
ByteFill:
    ldr r3, =ByteFill_c + 1
    bx  r3
    .pool
    thumb_func_end ByteFill
.endif
```

The macro (`include/macros/function.inc`):

```asm
.macro decomp_trampoline target_name:req, pad_bytes=0
    ldr r3, =\target_name + 1
    bx  r3
    .pool
    .if \pad_bytes > 0
      .rept \pad_bytes / 2
        nop
      .endr
    .endif
.endm
```

- `ldr r3, =C+1; bx r3` (4 bytes) + `.pool` literal word (4 bytes) = 8 bytes.
- `+1` explicitly sets the Thumb bit on the literal; `bx r3` is a tail
  call (LR untouched, C's `bx lr` returns straight to the orig caller).
- `pad_bytes` emits `pad_bytes/2` `nop`s so the slot keeps the orig size.
- **PAD = orig_body_size − 8.**
- Two sibling macros exist:
  - `decomp_trampoline_r3safe` — `push{r0}; ldr r0,=t+1; mov r12,r0;
    pop{r0}; bx r12` for 4-arg functions where r3 is a live arg.
  - flag-dependent callers use the *plain* trampoline + a naked C
    wrapper (`DECOMP_FLAG_WRAPPER`) that re-sets flags before return.

Build wiring:

- `make all` defines no `DECOMP_*` → `.ifndef` branch → original bytes →
  SHA matches retail.
- `make decompile` emits `--defsym DECOMP_<sym>=1` for every manifest
  entry → `.else` branch → trampoline → C body in `.c_code`.
- **534 functions** currently in the manifest.

## Strengths

- **One mechanism, two builds.** The same tree produces a byte-exact
  retail ROM and a C-overlay ROM. That's the whole reason incremental
  decomp is safe here.
- In-place: the function keeps its address, so every caller (incl.
  vtables / `.word` refs) still resolves without relocation.
- Per-function granularity → revert is just dropping a manifest line.

## Weaknesses / open questions

- **Trampoline is staging, not the goal.** Per memory
  [[project_end_goal_full_c]] the end state is fully relocatable C with
  no ASM; every trampoline is debt to unwind later.
- **Cycle drift.** Per [[trampoline_cycle_drift]] each trampoline adds
  ~6 cycles/call and can race VBlank on tight frames — so a
  partial-trampoline build can't be byte-parity validated on timing.
- **Manual PAD is a footgun.** `orig_body_size − 8` (or −10 at
  2-but-not-4-aligned starts) is hand-computed; a miscount fails from
  frame 0. The docs list it as the #1 pitfall.
- **`.pool` flush hazard (the scary one).** `.pool` flushes *every*
  pending literal, including ones from adjacent non-manifest functions.
  If the spill overflows the pad, downstream symbols shift and verify
  failures cascade through callers. The macro comment documents a prior
  fix attempt that regressed the opposite way and was reverted
  (issues/decomp-blockers.md #11). This is fragile and unsolved.
- **Docs drift.** docs/decomp-workflow.md shows `ldr r3, =FooBar_c+1`
  and "nop" padding — that matches the macro, good — but my own first
  pass and a couple of doc spots elsewhere describe padding as `.byte
  0`. Worth a consistency check.

## Verdict

**KEEP — necessary evil, but attack the drift root cause via relocation.**
(2026-05-29)

The trampoline mechanism stays: it's the only thing making safe
incremental decomp possible. But the real pain it creates —
[[trampoline_cycle_drift]] on **hotpath** functions racing VBlank — is
not inherent to decomp, it's inherent to *keeping the function in
place*. A trampoline is only required because downstream code holds the
function's original address.

### Design direction (new work item)
A function is **relocatable** if nothing references it by absolute
address — i.e. no `.word <sym>` / `.word <sym>+1` in data or vtables;
it's reached only by PC-relative `bl` (which the linker re-targets
freely). Such functions don't need to live at their original slot at
all.

Idea: **relocate everything relocatable to the bottom of the ROM**,
freeing contiguous space in the original region. That reclaimed space
lets a *hotpath* function's full C body sit inline at (or adjacent to)
its original address with **no trampoline** → no per-call `ldr+bx`
overhead → no VBlank drift for the functions that actually matter.

Caveats baked in:
- The hotpath function (or its immediate neighbors whose space we want
  to reclaim) must themselves be relocatable, or we can't free the slot.
- Need a concrete relocatability census first: how much of the ROM is
  already pure-`bl`-referenced vs. pinned by `.word`/jump-table/absolute
  pointers? That number bounds the whole strategy.

See [todo.md](todo.md) → "Relocation strategy".

### Relocatability census (run 2026-05-29)

A function is **pinned** if its address is taken anywhere — `.word <fn>`
/ `<fn>+1` in code OR data. Otherwise it's reached only by PC-relative
`bl` = **relocatable**.

Methodology note: the first pass scanned only `asm/*.s` and I worried it
missed pointer tables in `data/*.s` + the 23 `maps/*/data.s` (vtables are
data). Re-ran across **asm + data + maps** to be sure. Result: it barely
moved — data/maps added only **+41 pins** (883 → 924). The data-dir
pointer tables mostly reference data labels / local targets, or re-pin
functions already pinned in asm.

Final census (asm + data + maps), all numbers computed not hand-typed:

| | count | share |
|---|---|---|
| Total functions | 2664 | 100% |
| Pinned (`.word <fn>` in asm/data/maps) | 924 | 35% |
| **Relocatable (bl-only)** | **1740** | **65%** |

(pinned + relocatable = 2664 ✓)

Already-converted manifest (534): **493 relocatable (92%)**, 41 pinned.
We've been converting overwhelmingly relocatable functions — which is
why VBlank drift has been rare.

**CAVEAT — census "relocatable" is necessary but NOT sufficient.** The
census only checks for `.word <sym>` references to a function's *label*.
An absolute address can also be referenced *numerically* with no symbol
name: `ldr rN, =0x08XXXXXX`, `.word 0x08XXXXXX`, computed offsets from a
neighboring symbol, or mid-function entry points. A symbol may be
documented in some spots yet have an undocumented raw-address ref
elsewhere. So before actually relocating any symbol, a **hard gate**:
grep the ROM for the symbol's resolved absolute address (and nearby
addresses, for mid-function refs) in raw numeric form across asm + data
+ maps. Any hit → not safe to move unless that raw ref is fixed up too.
The census label-check is a candidate filter; the numeric-address check
is the real gate. (See todo.)

**Answers to the Feature 2 discussion questions:**
1. *How much is relocatable?* **~65% — two-thirds of the ROM**, confirmed
   against the data/maps pointer tables. Yes, really. The strategy works
   with the grain of the binary.
2. *Move relocatable code to the bottom to free hotpath space?*
   Mechanically feasible — 1740 movable fns, linker re-targets their
   `bl`s for free. Large reclaimable space.
3. *Hotpath/neighbors must be relocatable too?* Correct constraint. The
   VBlank IRQ **entry is pinned** (IRQ vector holds its absolute
   address), so we can't move the entry — but with 65% reloc density its
   callees and neighbors usually can move, so the play is "relocate
   around the pinned entry to open inline space, then inline the hotpath
   C body at its fixed slot with no trampoline."

Gap: functions are named `sub_XXXX`, so drift-sensitivity ranking needs
runtime call-frequency data — the signal the deleted tracker produced.
Promoted to its own work item (see todo "Hotpath identification").

### IRQ subsystem split early/late (refined 2026-05-29)

Initial verdict was "leave all IRQs for the end." Refined: split the
subsystem. The **vector install + dispatcher** (`start.s` writes
`0x03007FFC` ← `sub_3005B00`, an IWRAM dispatcher copied from ROM;
registration via `SetInterruptCallback`) is structural and must be
**de-risked early** — map its dependents and prove the *mechanism* is
safe to rework before the relocation push, so a surprise is cheap not
terminal. Only the **hot handler bodies** (per-frame VBlank work) wait
for the end, because they need inline-no-trampoline placement.

Terminology: the IRQ "vtable" is data (pointers); we rewrite the
**functions it points at**, not the table. In-place trampoline conversion
leaves the table untouched (pointer still resolves); only relocating a
target needs a mechanical pointer update. Full plan + verified structure
in todo.md → "IRQs: split the subsystem".

---
_Last updated: 2026-05-29 14:33:50 -0400_
