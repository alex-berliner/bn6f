# 06b — Build matrix + result log

## What it is today

Isolated per-patch builds only: each ROM enables exactly one symbol.
Clean attribution, but the **combined all-patches ROM (what ships) is
never tested**.

## Verdict (2026-05-30)

**EXPAND — do BOTH isolated per-patch AND the full combined build; both
equally important. Add a structured result log.**

### Build matrix
- Individual patches = the first N tests, indices `0000001..NNNNNNN`.
- The full all-patches build (and any other aggregate cases) live in a
  separate index range, e.g. `1000000_all_patch`, so they don't collide
  with per-symbol indices. (Mirrors the existing canary at 7000001.)

### Result log — `patch_result.log`
One row per test: id/name, pass/fail, suspected reason.

```
0000001_symbol1   | PASS | -
0000002_symbol2   | FAIL | vblank drift (example)
1000000_all_patch | FAIL | blahblahblah
```

- [ ] Columns: `id_symbol | verdict | suspected_reason`. **Open: what
      else?** Candidates — `bk2` (which fixture failed), `first_diff`
      (frame/addr), `duration`, `timestamp`. Decide the minimal useful set.
- [ ] "Suspected reason" implies classification (drift vs logic vs
      missing-gate vs not-called). Where does that judgement come from —
      heuristic, or filled in by hand?

---
_Last updated: 2026-05-30 12:10:15 -0400_
