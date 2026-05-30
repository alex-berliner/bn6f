# 06f — Parallel subprocess fan-out

## What it is today

The orchestrator runs in phases: build orig → build per-patch
(sequential, manifest-locked) → **hash all** (rom × bk2) pairs in
parallel via subprocess workers → compare in parallel. Each hash job is
a separate `bn6f-validate hash` subprocess, so per-process address space
isolates any mGBA global state.

("hash all" = generate the per-frame hash stream for every (ROM × bk2)
combination — orig and every patch — in parallel; Phase 4 then diffs
each patch's streams against orig's.)

## Verdict (2026-05-30)

**GOOD.** Subprocess fan-out is the right call — simple, and the
process-per-job isolation neatly avoids mGBA global-state contamination.
Keep it.

- Note: if 06a moves to full-state diffing and 06c skips uncalled cases,
  the set of jobs fanned out changes, but the fan-out mechanism stays.

---
_Last updated: 2026-05-30 12:10:38 -0400_
