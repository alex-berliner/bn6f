# 08e — Broken real byte_fill.c (collateral finding)

## Finding (verified 2026-05-30)
`src/c/byte_fill.c` — the REAL ByteFill conversion — contains the
**XOR-broken body**, identical to the canary:
```c
void ByteFill_c(u8 *dst, u32 count, u8 byte) {
    while (count-- > 0) dst[count] = byte ^ 0x01;  /* canary divergence */
}
```
with a "DELIBERATELY BROKEN" header. And:
- `ByteFill` IS in the manifest (`tools/decomp_manifest.txt:14`).
- asm has the normal `.ifndef DECOMP_ByteFill` → `ByteFill_c` trampoline
  (`asm/asm00_0.s:824/839`).
- committed by `0751da2a "Convert ByteFill to C via .ifndef trampoline"`.

So `make decompile` **ships a corrupted ByteFill** — the canary copy got
committed as the real conversion.

## Implications
- The decompile build is wrong RIGHT NOW for ByteFill (any frame relying
  on a ByteFill'd buffer diverges). If validate_results currently shows
  ByteFill PASS, that's alarming (would mean ByteFill's writes never
  reach a hashed pixel in any fixture — i.e. a coverage hole, ties 06c).
- Two files with the same broken body + near-identical comments is a
  smell that invites exactly this copy-paste mistake.

## Direction
- [x] **FIXED 2026-05-30** — `src/c/byte_fill.c` now `dst[count] = byte;`
      (correct, matches orig ASM r0=dst/r1=count/r2=byte). XOR removed.
- [x] **Validation confirmed.** Broken version: FAIL @ frame 17
      (coldboot/intro), 6628 (tutorial) — so the corruption WAS visible,
      the validator catches it (incidental real-canary). Fixed version:
      **PASS on all 3 bk2s**. So ByteFill had simply never been validated
      since the bad commit `0751da2a`; no coverage hole — it just shipped
      unchecked.
- [ ] (Process) canary + real impl sharing a body is the root cause;
      keep them clearly distinct.

## Rating
**BUG — fixed.** (2026-05-30) Not a feature; a real shipped-corruption
bug, now corrected in working tree.

---
_Last updated: 2026-05-30 13:05:50 -0400_
