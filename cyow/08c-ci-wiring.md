# 08c — CI wiring

## Finding
`canary.sh` is **not wired into anything**. `tools/ci.sh` runs `make
all`, `make decompile`, `make verify` (and `verify` references a removed
harness — separate rot), but never calls `canary.sh`. Grep finds zero
references to the canary in Makefile/ci.sh/docs.

## Why it matters
The safety net exists but nothing pulls it. The validator could silently
break and no automated step would notice — defeating the canary's whole
purpose. A tester-of-the-tester that isn't run is decoration.

## Direction
- [ ] Run `canary.sh` as a gate **before** trusting any validation run
      (CI phase, and/or as the first thing `bn6f-validate run` does).
- [ ] Fix/replace the stale `make verify` reference in `ci.sh` while
      there (it points at the removed bn6f-track harness).

## Rating
**BAD — symptom of a non-unified harness.** (2026-05-30) The deeper issue
the user named: *why is there a separate `canary.sh` at all?* It's a
standalone bash script bolted next to the Rust validator, wired into
nothing. The canary self-test should be a **first-class part of the
unified harness** (a `bn6f-validate` subcommand / built-in phase), not an
orphan script. Unify it in.

- [ ] Fold the canary self-test INTO the validator (e.g. `bn6f-validate
      selftest`, or run automatically as phase 0 of every `run`), and
      delete the standalone `canary.sh`.
- [ ] Kill the stale `make verify` reference in `ci.sh` (removed harness).
- [ ] CI calls the unified harness, which self-tests before trusting a run.

---
_Last updated: 2026-05-30 13:02:53 -0400_
