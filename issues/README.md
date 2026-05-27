# issues/

Tracked work, blockers, and reference docs for the decomp project.

## Contents

| File | What |
|---|---|
| [`project_outline.md`](project_outline.md) | High-level goals, end state ("all C, no ASM") |
| [`decomp-blockers.md`](decomp-blockers.md) | Patterns currently blocking larger-function conversion |
| [`concerns/`](concerns/) | Reference docs for ABI, IRQ, stack, timing, etc. |

## decomp-blockers.md

Each entry describes a pattern in the orig ASM that the current
decomp infrastructure can't cleanly handle yet. Entries link to
example functions and propose what infrastructure would need to
change to unblock them.

Use this as the work queue:
- Pick an entry whose unblock fix is in scope.
- Implement the fix (e.g., a new wrapper macro, a Makefile change).
- Convert a function that previously hit the pattern.
- Verify is green → close the blocker entry.

## concerns/

These are deep-dive reference docs, one per topic. They explain
constraints that *every* conversion must respect:

| File | Topic |
|---|---|
| `01-calling-convention-abi.md` | AAPCS variant, why agbcc |
| `02-global-state-reentrancy.md` | shared EWRAM/IWRAM accesses |
| `03-interrupts-timing.md` | vblank, hblank, sound DMA cadence |
| `04-rom-vs-ram-placement.md` | `.text` / `.data` / `.c_code` placement |
| `07-linker-build-patching.md` | trampoline pattern, manifest gating |
| `08-stack.md` | banked SP per mode, when SVC stack matters |
| `09-correctness-verification.md` | the verify model + blind spots |
| `10-emulator-requirements.md` | why libmgba 0.11, BIOS handling |

Read the relevant concern before converting a function that touches
its domain (e.g., read `03-interrupts-timing.md` before converting
anything called from the vblank handler).

## Filing a new blocker

If you hit a pattern that's not yet a blocker, add an entry to
`decomp-blockers.md` following this template:

```markdown
## NN. Pattern name

**Symptom**: what you observed (e.g., "verify fails on every pair
even though C body is identical to orig")

**Root cause**: what's actually happening (1-2 paragraphs)

**Example**: function name + ASM snippet showing the pattern

**Unblock**: what infrastructure change would fix the class
(new macro? extend the trampoline macro? new ASM rule?)

**Affected functions**: rough count + list of representative ones
```

Number sequentially. Close by removing the entry (and noting it in
the commit message) once unblocked.
