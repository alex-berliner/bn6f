# Direct CPU register reads in custom_cb

**Status:** implemented
**Impact:** ★★ (medium — affects the per-instruction hot path)
**Effort:** medium (need to verify bindgen struct layout for libmgba 0.11)

## Problem

The per-instruction callback `custom_cb` (`main.rs` ~line 361) fires
for every executed Thumb/ARM instruction. On every call it reads PC
and CPSR via libmgba's `readRegister` function pointer:

```rust
let read = (*core).readRegister.unwrap_unchecked();
PC_REG.with(|name| {
    let _ = read(core, name.as_ptr(), &mut pc_i);
});
CPSR_REG.with(|name| {
    let _ = read(core, name.as_ptr(), &mut cpsr_i);
});
```

That's two indirect function-pointer calls + a name-based dispatch
inside libmgba per CPU step. For `verify-spam` (18600 frames × ~280K
cycles/frame ≈ 5 billion instructions emulated), this is multiplied a
*lot*.

## Approach

Read directly from the CPU struct fields the bindgen-generated bindings
should expose. For ARM7TDMI:

- `(*(*core).cpu).gprs[15]` for PC
- `(*(*core).cpu).cpsr.packed` for CPSR (or check whether bindgen
  exposes the bitfield struct; if not, read the raw `u32`)

This dodges both indirections per step.

## Implementation notes

- Need to verify what's actually exposed in
  `target/release/build/.../mgba_sys.rs`. The `mCore` struct stores
  `cpu` as `*mut c_void` historically; libmgba 0.11 may have changed
  this. If still `void*`, cast via the GBA-specific layout (`struct
  ARMCore`).
- The other Claude tried HW breakpoints to avoid the callback
  entirely and it was 10× slower (libmgba 0.11 linear-scans bps). This
  optimization is **orthogonal**: keep the callback, just make it
  cheaper.
- Be careful with the safety story — reading directly from the cpu
  struct is unsafe but no more so than `readRegister` itself.
- Micro-benchmark first: a 60-second `smoke 60000` before vs after
  should show whether this matters.

## Results

`make verify` (bk2-only harness, 4154 pairs):

| State | Wall | Δ vs prior | Δ vs baseline |
|---|---|---|---|
| Pre-04 (10A + 05 in place) | 1:53.07 | — | — |
| Post-04 | **1:06.28** | **-41.4%** | **-41%** |

All 4154/4154 pairs still pass.

Big win. The per-instruction callback fires for the full demo run +
every isolated-run step (millions of times per pair × thousands of
pairs). Switching `readRegister` → direct `(*cpu).gprs[15]` /
`gprs[14]` / `cpsr` reads removed two function-pointer indirections +
name-based dispatch per step. By far the largest single gain in this
batch.

Layout safety is checked once at `attach_debugger` time via
`Core::verify_cpu_layout`, which cross-validates the direct reads
against `readRegister`. If a future libmgba bump reorders `ARMCore`,
this trips loudly instead of producing garbage PCs in the hot path.
