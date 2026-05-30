# 08a — Canary concept (test the tester)

## What it is
A deliberately-broken conversion (`ByteFillCanary_c`, XORs each written
byte with 0x01) that the validator MUST flag as FAIL. `canary.sh` asserts
FAIL on every bk2; exit 0 = caught, 1 = validator broken, 2 = infra.

## Why it matters
A green validation suite is meaningless if the suite can't go red. The
canary makes "the validator actually works" a falsifiable, tested claim
— rare and correct.

## Rating
**GOOD — high priority.** (2026-05-30) Keep the concept. User wants to
**manually inspect all of this** when the new harness is built — the
canary path is high-prio for hands-on review, not just auto-trust.

---
_Last updated: 2026-05-30 13:02:46 -0400_
