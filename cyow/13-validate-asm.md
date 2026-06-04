# 13 — `tools/validate_asm.py` / `make validate` (static disasm-diff oracle)

## What it is

A **static** equivalence checker, parallel to the runtime pixel/full-state
oracle (bn6f-validate). It:

1. disassembles `bn6f_orig.elf` and `bn6f.elf` (`objdump -d`);
2. **normalises** each function's instructions to hide compiler artefacts:
   - EWRAM/ROM addresses → `%ewram` / `%rom`
   - branch targets → mnemonic only (drop concrete address)
   - returns (`pop {pc}`, `mov pc, lr`) → canonical `bx lr`
   - `tst rN, rN` → `cmp rN, #0`
   - caller-saved regs (r0–r3/r12/ip, outside reg-lists) → `%tmp`
   - strip trailing literal-pool entries
3. diffs the normalised forms per (asm_sym, c_sym) pair.

Pairs come from a **hardcoded ~22-entry `DEFAULT_PAIRS`** (battle /
scenario-effect functions) using a `c_<sym>` prefix, or an optional pair
file. Exit 0 = all pass.

## Honest read — why it loses

1. **Competing oracle.** It's a second source of truth next to the
   authoritative runtime pixel/full-state check. 8c's verdict was *unify
   the harness* (fold canary into the validator, delete `canary.sh`), not
   add parallel oracles.
2. **Lossy normaliser → can false-PASS.** `%tmp` register collapsing,
   pool-stripping, and return/tst canonicalisation approximate semantic
   equivalence, which is undecidable in general. A normaliser that's too
   aggressive silently passes a real divergence. That directly violates
   the project bar: *make errors impossible by construction*, not
   "scanned for." A static check that can lie is worse than one
   ground-truth runtime oracle.
3. **Stale convention.** `c_<sym>` prefix + the fixed early-batch pair
   list are from an older scheme; current trampolines use the `<sym>_c`
   suffix. The pair list isn't maintained against the manifest.

## Verdict

**RETIRE.** The runtime pixel/full-state oracle (Features 6–8) is ground
truth and already runs per-patch. A fast-but-lossy static diff adds a
trust hazard (false PASS) without adding authority. If a *fast pre-filter*
is ever wanted, it must be exact (not a hand-tuned normaliser) — out of
scope for now. Delete `validate_asm.py` and drop the `make validate`
target in the end-of-review cleanup (touches the Makefile → batch it).

---
_Last updated: 2026-06-04 13:43:35 -0400_
