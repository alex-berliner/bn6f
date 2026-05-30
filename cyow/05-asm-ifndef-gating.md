# 05 — ASM `.ifndef` gating (mechanically REPLACING the symbol)

> Split from the old combined "manifest + build flavors" feature on
> 2026-05-30. This feature is **problem B only**: how the build swaps an
> ASM body for the C version. WHICH symbols to swap is Feature 04.
> The trampoline byte-mechanism itself is Feature 02.

## What it is

Each convertible function in `asm/*.s` is wrapped:

```asm
.ifndef DECOMP_FooBar
    < original body >
.else
    decomp_trampoline FooBar_c, <pad>
.endif
```

`make all` defines no `DECOMP_*` → original bytes → SHA-exact retail.
`make decompile` defines them (per enabled manifest entry) → trampoline
to C. Two linker scripts differ only by an 8→16 MB rom region bump + an
appended `.c_code` section.

## Weaknesses

- **Hand-edited per conversion.** Every conversion currently requires a
  manual `.s` edit to add the gate — error-prone, and the source of the
  three-way drift with the manifest + C file.
- **Manual PAD** (`orig_size − 8`) — Feature 02's footgun.
- Single `rom.o` (rom.s `.include`s all 38 asm files) means the linker
  **cannot** auto-pick C-vs-ASM (weak symbols need separate objects), so
  selection MUST happen at assemble-time → a gate of some kind is
  unavoidable unless we break the monolith (rejected — SHA risk).

## Verdict

**KEEP `.ifndef` + single `.o`, but STUB ALL GATES ONCE via a script.**
(2026-05-30)

Do not break the single `rom.o`. Instead, a one-time script wraps **every**
`thumb_func_start` function in the gate skeleton with auto-computed PAD.
After that:

- `.else` only assembles when `DECOMP_<sym>=1` (enabled JSON record), so
  a stubbed-but-unconverted function is inert — always original branch →
  `make all` still SHA-matches.
- Per-conversion becomes: add C file + flip JSON `enabled`. **`.s` files
  are never hand-edited again** → drift structurally cannot arise.
- Auto-PAD kills Feature 02's manual-pad footgun tree-wide.

### Implementation risks (in the stub script)
- **1380 functions carry embedded literal pools** in their body — parser
  must find body extent correctly, not regex-naively.
- **`.pool` flush hazard** (Feature 02) — pad/pool interaction for
  data-carrying functions is the known-fragile part.
- 5 multi-entry (`thumb_local_start`) functions need manual handling.
- Must verify `make all` still SHA-matches after the bulk stub — the
  whole safety claim rests on `.else` being inert when undefined.

**Left as-is:** mtime/stash force-rebuild workaround; fixed `.c_code`
region length.

See [todo.md](todo.md) → "Feature 5".

---
_Last updated: 2026-05-30 11:36:36 -0400_
