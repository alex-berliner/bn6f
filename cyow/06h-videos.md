# 06h — Videos (mp4 side-output)

## What it is today

`--videos` renders libx264 CRF 28 mp4s for human spot-check, orig
symlinked alongside each patch render. Already explicitly NOT the
correctness signal.

## Verdict (2026-05-30)

**KEEP, but strictly informal + on-demand.** Videos are for the user's
informal review **only**, and only when explicitly requested.

- [ ] Off by default. Behind a flag the user can tell Claude to enable
      (never produced as part of a normal validation run).
- [ ] **Optimize for small filesize** — these are throwaway review
      artifacts, not archives. (Tune CRF/scale/codec for size over
      fidelity; spot-check doesn't need pristine quality.)
- [ ] Never load-bearing for pass/fail. The correctness signal is the
      state diff (06a). This is the "we went too far into the weeds on
      video comparison" correction — video is review sugar, nothing more.

---
_Last updated: 2026-05-30 12:10:43 -0400_
