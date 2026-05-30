# 06c — bk2 metadata + call-coverage gating

## What it is today

3 bk2 fixtures, no knowledge of which functions each one actually
exercises. Every patch is tested against every bk2 regardless of whether
its symbol is ever called → wasted work and meaningless passes.

## Verdict (2026-05-30)

**BUILD IT — this is a big deal.**

### bk2 metadata build step
- [ ] A build step that produces **per-bk2 metadata** into the build
      folder (`build/...`, NOT persistent/committed).
- [ ] Part of that metadata: **per-function call counts** — how many
      times each function is called during each bk2 replay. (This is the
      hotpath/coverage signal lost when bn6f-track was removed — see the
      ⭐ Hotpath identification item; likely the same instrument.)

### Coverage-gated test selection
- [ ] Cross-reference each symbol-under-test against whether it is
      **actually called** in a given bk2. A patch whose function is never
      called in any bk2 is untestable by that bk2 — **skip it**, don't
      report a meaningless PASS.
- [ ] The full test-suite run should **ignore useless test cases**
      (symbol × bk2 pairs where the symbol isn't called).
- [ ] Surface "symbol not covered by ANY fixture" as its own status — it
      means we have no behavioural evidence for that conversion at all.

### Ties
- Feeds 06b's result log (a skipped case is a distinct verdict).
- Same call-count instrument the relocation/hotpath work needs (Feature 2).

---
_Last updated: 2026-05-30 12:10:23 -0400_
