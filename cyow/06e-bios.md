# 06e — BIOS

## What it is today

Runs under libmgba's **HLE BIOS**, not the real one. The bk2s were
recorded against HLE.

## Verdict (2026-05-30)

**NEVER use HLE BIOS. Never.**

- [ ] Require the real GBA BIOS for all validation (user's verified dump:
      [[gba_bios_path]] at `/home/alex/gbabiosworld.bin`).
- [ ] If a bk2 was not recorded against the real BIOS, **fail all its
      tests** and give that as the explicit failure reason (a distinct
      verdict in 06b's log, e.g. `FAIL | bk2 not real-BIOS`).
- [ ] Existing fixtures recorded under HLE must be re-recorded against
      real BIOS (or discarded). Audit the current 3.

### Note
This may interact with 06a: real-BIOS boot timing differs from HLE, so
boot-sequence state diffs must be computed against a real-BIOS orig
baseline, not the HLE one currently in use.

---
_Last updated: 2026-05-30 12:10:32 -0400_
