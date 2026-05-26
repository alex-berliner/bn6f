# Decomp blockers — what's keeping us from bigger functions

Patterns encountered in the ASM that the current C-decomp toolkit
either can't handle, handles awkwardly, or that slow down conversion
per-function. Sorted roughly by impact on the corpus (how many
functions each blocker affects).

Each item:
- **Symptom:** what we see when we hit it
- **Why:** mechanical cause
- **Status:** done / proposed / open
- **Unblock estimate:** rough fns gained once solved

---

## 1. Local-symbol callees (`thumb_local_start`) — OPEN

**Symptom:** target function (small, otherwise pickable) calls a
helper that's declared with `thumb_local_start` instead of
`thumb_func_start`. The helper has no global symbol, so a C `extern`
declaration can't link to it. We must skip the caller.

**Why:** the original ASM marked the helper as file-local for size
or to enforce a calling convention the helper assumes (e.g. uses
r4-r7 outside AAPCS). The local-symbol declaration is preserved
verbatim from the disassembly.

**Status:** open. Hit during candidate scan repeatedly (sub_8010DDA,
sub_801102A, sub_80062D0/D6, sub_802E490, GetBattleModeFromBattleSettings,
many more).

**Unblock:** mechanically promote `thumb_local_start` → `thumb_func_start`
for the entries we want to call from C. Each promoted helper itself
becomes pickable as a decomp target. Should affect ~500-2000 functions
transitively.

**Effort:** low. Could be a one-shot script that walks the asm files
looking for `thumb_local_start` blocks whose names are referenced by
fns we want to decomp, and converts them to `thumb_func_start`. Need
to validate doesn't break anything — the local→global change is
purely additive (adds the symbol to the global namespace).

---

## 2. Indirect-call dispatch IN CALLER (`mov lr, pc; bx rN`) — OPEN

**Symptom:** the function we want to decomp has a `mov lr, pc; bx rN`
sequence inside its body, manually dispatching to a function pointer
loaded from a table. Common in scenario/scene callbacks and per-actor
update dispatchers. 4+ functions in the asm00_* region use this for
animation, BG-scroll, and effect dispatching.

**Why:** thumb-1 lacks `blx` (branch with link and exchange). The
manual `mov lr, pc; bx rN` is the original compiler's workaround for
indirect calls. C source would have written `(*fp)(args)` and the
compiler emitted this sequence.

In C-decomp form, agbcc compiles `(*fp)(args)` to... probably the
same `mov lr, pc; bx rN` pattern? Or to a stub `__call_via_rN`?
Uncertain — needs investigation.

**Status:** open. Vtable-CALLEE side (when we're the dispatched fn)
is fixed via `DECOMP_VTABLE_WRAPPER`. Caller side (when we dispatch)
needs verification — might just work if agbcc emits the same sequence,
or might need a `CALL_VIA_FN_PTR(fp, args...)` macro.

**Unblock:** test by decompiling one such caller (e.g.
`ProcessGFXAnims` once shrunk) and verifying. If broken, write a
macro. Should affect ~300-800 functions.

**Effort:** low (test) → medium (write helper macro if needed).

---

## 3. Multi-return (r0 + r1[, r2…]) — OPEN

**Symptom:** function returns multiple values via r0, r1, r2. AAPCS
allows r0+r1 for 64-bit returns, but games freely use r0/r1/r2 as
3-value returns. C function signatures can't express this without
struct-return.

Examples: `screenFade_80062C8` (r0 + r1), `sub_8000DE0` (r0+r1+r2),
`sub_800362C` (r0+r1+r2), `math_getThrowSpeeds` (r0+r1), several
coordinate/RNG helpers.

**Why:** ASM-era hand-written assembly didn't care about C ABI;
multi-return is just "fill multiple regs, return."

**Status:** open. Currently always skip on detection.

**Unblock options:**
- (a) Struct return: declare `struct ABC { u32 a, b, c; }` and
  return it. agbcc's ABI for struct returns varies by size; need to
  verify it matches the original ASM register layout.
- (b) Naked function with explicit asm: write the function in inline
  asm with hand-set r0/r1/r2 at exit. Loses readability but works.
- (c) Pass-by-pointer for secondary returns: `u32 fn(u32 *out_r1,
  u32 *out_r2)` — but callers still use the ASM convention, so
  this only works if we change callers too (huge refactor).

Most viable: (b) for tight multi-returns; (a) for cleaner cases
where agbcc's struct-return matches.

**Unblock estimate:** ~50-200 functions are explicit multi-return.
Plus dozens of "incidental" cases where the original sets r1 but
nobody checks → those are NOT real multi-returns and can be done
with single-return C as soon as we have a way to verify "nobody
reads r1 across this call."

**Effort:** medium. Needs a small ABI investigation + a wrapper
macro.

---

## 4. SVC (BIOS) calls — OPEN

**Symptom:** function contains `svc N` instructions — direct calls
to the GBA BIOS (math intrinsics, decompression, sound, etc.).

Examples: `calcAngle_800117C` (svc 0xa = ArcTan2),
`math_getThrowSpeeds` (svc 6 = Div, svc 8 = Sqrt).

**Why:** GBA BIOS provides hardware-assisted math, decompression,
memory copy, etc. Hand-written ASM uses them directly.

**Unblock options:**
- (a) C-side intrinsic wrappers: declare `extern u32 SVC_ArcTan2(s32
  x, s32 y)` etc., implemented in a small inline-asm file that
  issues the SVC.
- (b) Replace with software equivalents (lose cycle-accuracy with
  the original — would fail verify).

(a) is clearly right. Once written, every SVC site can be a normal
C call.

**Unblock estimate:** ~30-100 functions touch SVCs directly. More
indirectly (called through helpers).

**Effort:** low. Half a day to enumerate SVCs we hit + write the
wrappers + verify.

---

## 5. High register usage (r8/r9/r12) — OPEN

**Symptom:** function uses r8/r9/r12 in its body. agbcc generates
shuffles to/from low registers for any high-reg access (`mov rL,
rH; ... ; mov rH, rL`) which complicates trampolining. Push/pop
of r8-r12 doubles the prologue/epilogue size.

Examples: most `applyLayerEffect*`, `npc_init_*`, `sub_8003BF4`,
`ProcessGFXAnims` use these registers for inner-loop state.

**Why:** thumb-1 has only 8 low registers; long-lived state spills
to r8-r12. The hand-written ASM uses them directly; agbcc isn't as
clever about this.

**Status:** open. Currently always skip on detection.

**Unblock options:**
- (a) For fns that ONLY use r10 or r5 ambient (Toolkit / BattleObject),
  the existing `register asm("rN")` pattern works.
- (b) For multi-high-register fns, write a naked-fn template that
  matches the original prologue/epilogue and lets agbcc compile the
  body normally.
- (c) Accept slower-but-correct C compilation (different ASM, same
  behaviour) for fns where the high-reg use is incidental.

**Unblock estimate:** ~500-1000 functions. Many of the medium-sized
asm00_* dispatchers fall here.

**Effort:** medium. Probably (c) is the right answer for most of
these — let agbcc do what it does, verify behaviour. The ones that
break under (c) need (b).

---

## 6. Inline pool data inside function region — DONE (partially)

**Symptom:** function "region" (from `thumb_func_start` to
`thumb_func_end`) includes 4-byte word entries used as data
constants. When we trampoline-replace the function code, the data
position must be preserved if anything else references it; otherwise
it can be overwritten with `nop` padding.

**Status:** trampoline pool-leakage bug fixed
(`include/macros/function.inc` 91c15204). The fix accidentally
clarified this: `.pool` no longer pulls in adjacent functions'
literals. So a function with its OWN inline pool (referenced only
internally) is now safely overwriteable.

**Remaining gotcha:** functions whose region contains data
referenced by OTHER functions (shared pool entry) can't be naively
overwritten. The data must survive at its exact address. Currently
the trampoline pad just emits nops — overwrites everything. Need
detection or a `decomp_trampoline_preserve_pool` variant.

**Unblock estimate:** rare but real — sub_801002C-style fns where
data after the body is shared. Maybe 20-50 functions hit this.

**Effort:** low. Add a variant macro that takes a "pool_keep_bytes"
parameter specifying how many bytes after the trampoline to leave
untouched (the original data).

---

## 7. Code-or-data embedded after function body — OPEN

**Symptom:** function region contains what looks like data
(`byte_*: .byte ...`) but the byte pattern is actually thumb
code reachable via a separate code pointer (often through the
function's own pool).

Example: `sub_801002C`'s region contains `byte_80100A8: .byte ...`
which is actually a small subroutine called via the `.word
byte_80100A8` pool entry.

**Why:** original ASM compilers sometimes embedded small helpers
inside the calling function's region for locality.

**Status:** open. Currently skip on detection.

**Unblock options:**
- (a) Detect via "the data table starts with thumb-instruction-looking
  bytes" heuristic; carve it out into a separate fn before trampolining.
- (b) Manual case-by-case — annotate via comment and trampoline
  while preserving the data region.

**Unblock estimate:** dozens of fns. Probably hand-pick the obvious
ones.

**Effort:** medium.

---

## 8. Typed struct accesses — OPEN

**Symptom:** every conversion writes raw byte-offset pointer
arithmetic (`*(u8 **)(r10p + 0x24)` style) because there's no
typed C struct definition for Toolkit / BattleObject / etc. on
the C side.

This isn't a correctness blocker — works fine — but it's a
*scalability* blocker for medium-and-up functions: a 40-instr
fn touching 8 distinct struct fields is much harder to write
correctly with byte offsets than with `obj->Foo` syntax.

**Why:** struct layouts only live in `include/structs/*.inc` (ASM
view). The C side has only `types.h` primitives.

**Status:** open. User feedback flagged this explicitly.

**Unblock:** create `src/c/decomp_structs.h` mirroring the .inc
layouts: Toolkit, BattleObject, AIData, CollisionData, GameState,
OWPlayerObject, NaviStats, ScreenFade, ObjectHeader, Chatbox,
CutsceneState, ScenarioEffectState. Then `register Toolkit *toolkit
asm("r10")` and `toolkit->CurFramePtr` reads cleanly.

**Unblock estimate:** doesn't gain new functions per se, but
makes every medium/large conversion ~30% faster + lower bug rate.

**Effort:** half-day to a day. Many structs already documented in
the memory cheatsheet; codify in C headers.

---

## 9. Trampoline size for tiny fns (< 8 bytes) — OPEN

**Symptom:** functions whose body is < 8 bytes (e.g. 4-byte
`push/pop` stubs, 6-byte 3-instruction fns) can't be trampolined —
the trampoline itself is 8 bytes (at 4-aligned) or 10 (at 2-aligned).
Replacing a 4-byte fn with an 8-byte trampoline shifts downstream
symbols.

**Status:** open. Currently always skip on detection.

**Unblock options:**
- (a) Inline these tiny fns at their call sites (no trampoline
  needed, no decomp ROM modification). Doesn't decompile them, but
  removes them from the "uncovered" list.
- (b) Find a 4-byte indirect-jump that's same-or-smaller than the
  original. Not feasible in thumb-1.
- (c) Mark them as "not decompilable in place; revisit at final
  relocation pass."

(a) and (c) are both reasonable. (c) requires no work now and
defers to the "end-of-project full relocation" phase.

**Unblock estimate:** ~200-400 ultra-tiny fns.

**Effort:** none (defer).

---

## 10. Function pickability tooling — OPEN

**Symptom:** the candidate-picking step keeps inspecting fns by
hand and discovering they hit one of the above blockers. ~half of
the time spent per iteration is "I picked this; it has problem X;
revert and pick again."

**Status:** open. Skill doc lists what to grep for; humans still
do the screening.

**Unblock:** a `tools/find_decomp_candidates.py` (or shell) script
that walks the asm files and emits a ranked list of pickable fns,
auto-rejecting:
- not 4-byte-aligned addresses
- not 4-12 instructions
- `mov lr, pc; bx` patterns
- `svc` opcodes
- multi-return signatures (r1 written after BL with no overwrite)
- callees declared `thumb_local_start`
- vtable membership (`.word <sym>` anywhere)
- high-reg use (r8/r9/r12 referenced in body)
- inline-pool data references from outside the fn
- already in manifest

Output sorted by "easiest first" (instruction count, similarity to
recent successful conversions).

**Status:** open.

**Unblock estimate:** doesn't gain new functions; cuts iteration
overhead by an estimated 40-60% on candidate-picking.

**Effort:** half-day.

---

## Priority order (my read)

If goal is "maximize decompiled-fn throughput in next week":

1. **Local-symbol promotion (#1)** — opens hundreds of fns, mechanical.
2. **SVC wrappers (#4)** — small set but unblocks math-heavy fns.
3. **Typed struct header (#8)** — speeds every future conversion.
4. **Candidate-picker tool (#10)** — speeds iteration.
5. **Multi-return wrapper (#3)** — medium-effort, moderate yield.
6. **Indirect-call IN caller (#2)** — test first; may already work.
7. **Inline pool preservation variant (#6)** — small set.
8. **High-reg handling (#5)** — biggest unblock but trickiest;
   probably the *last* one before we move to "rewrite the dispatch
   layer entirely" phase.

Items 9 (tiny fns) and 7 (code-or-data embedding) are deferred.
