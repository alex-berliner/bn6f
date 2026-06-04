# 10 — Multi-agent coordination layer (`AGENTS.md` + `tools/claim.py`)

## What it was

A protocol for running several agents (or humans) on decomp in parallel,
each in its own `git worktree`/branch, merging back to `master`. Five
parts:

- **10a — worktree-per-agent.** `git worktree add` per branch so each
  agent has its own object tree (`rom.o`, `bn6f.elf`, per-patch validator
  builds) and they don't clobber each other mid-build.
- **10b — file-locality ownership.** "No two agents touch the same
  `asm/*.s`." Manual pre-split (asm00 / asm03 / menus / overworld) to
  dodge textual conflicts in hot asm files.
- **10c — sorted manifest.** `decomp_manifest.txt` kept alphabetical,
  insert-in-position, so concurrent appends rarely line-conflict.
- **10d — `claim.py` ledger.** `claims.txt` advisory ledger; `claim AGENT
  SYM...` rejects symbols already in the manifest or held by another
  agent; `--release`, `--list`. Git is the real serializer.
- **10e — merge discipline.** Validation (`bn6f-validate run`) is the
  merge gate; rebase often; don't edit shared infra unannounced.

## Why it's being purged now

Earlier verdicts gut the premise of most of it **before** we'd build the
real version:

- **10b + 10c collapse into Features 4/5.** Once Feature 5 stubs *all*
  gates in one pass, agents stop editing `asm/*.s` entirely — they only
  add a new `src/c/*.c` (one file per function, inherently conflict-free)
  and flip a manifest flag. The whole reason file-locality (10b) and
  sorted-txt insertion (10c) exist — textual conflicts in shared asm /
  one flat manifest file — disappears. Feature 4's JSON manifest
  (per-record) removes the remaining merge surface.
- **10d / `claim.py`** hard-reads the flat `decomp_manifest.txt`
  (`read_manifest()`), so it breaks under Feature 4 anyway, and its main
  payoff (avoiding asm merge conflicts) is mostly Feature 5's job now.
- **10a + 10e** are sound and survive — but they're git hygiene +
  validation discipline that we'll re-document against the new
  (JSON-manifest, stub-all) workflow when we actually return to parallel
  work.

Rather than maintain a coordination layer built around a workflow we're
about to replace, we remove it and rebuild it later on the right
foundation.

## Verdict

**PURGE NOW, REDESIGN LATER.** Deleted `AGENTS.md` and `tools/claim.py`
(no `claims.txt` existed; no external references — clean blast radius,
recoverable from git history). Revisit multi-agent coordination *after*
Features 4 (JSON manifest) and 5 (stub-all) land, at which point:

- **keep** worktree-per-agent (10a) and validation-as-merge-gate +
  rebase discipline (10e), re-documented against the new workflow;
- **rebuild** the claim ledger (10d) against the JSON manifest, scoped
  to "dedupe in-flight `*_c` work" rather than asm-conflict avoidance;
- **drop** file-locality (10b) and sorted-txt insertion (10c) as
  obsolete.

---
_Last updated: 2026-06-04 13:39:04 -0400_
