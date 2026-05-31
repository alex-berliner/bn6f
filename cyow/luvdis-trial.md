# Luvdis trial — modern reproducible disassembly + auto-trampoline-wrap

Goal: can we regenerate the disassembly from the ROM with a modern,
scriptable, free tool (replacing the one-time IDA Pro + PseudoTerminal
session, see [history-asm-split](history-asm-split.md)) — and extend it to
emit every function already wrapped in the Feature-5 gate skeleton?

Tool: **Luvdis** (`github.com/aarant/luvdis`), pure-Python GBA-native
disassembler with function discovery + code/data separation. splat was
ruled out (MIPS only — N64/PSX/PS2/PSP, no ARM).

## What was verified (real runs, matching ROM sha 0676ecd4)

1. **Faithful disassembly.** Luvdis output is instruction-identical to the
   existing asm. `sound_8000630` came out the same op-for-op; only cosmetic
   diffs (`@` vs `//` comments, auto pool-label names `_08000870` vs
   `off_8000870`, raw literal `=0x0814EA59` vs symbolic `=sub_814EA58+1`).
2. **Seeding reproduces names + the file split.** Luvdis takes a config of
   `[thumb_func|arm_func] <addr> <module> <name>` lines. Blind discovery
   found 2 functions in 64 KB; seeded with our existing symbols it placed
   12169. The `module` field routes each function to its file, so the
   current split (chatbox.s, asm00_0.s, …) is reproduced from config.
   Generator: `tools/gen_luvdis_config.py` (name+module from asm, addr from
   bn6f.map; 12639 functions emitted, ~900 unresolved nullsub/map-artifact
   addresses to clean up).
3. **Auto-trampoline-wrap at generation time.** Because Luvdis emits a
   uniform `thumb_func_start NAME / NAME: @ <addr> / body` shape with a
   per-function address comment, a post-pass wraps every function in
   `.ifndef DECOMP_NAME / orig / .else / decomp_trampoline NAME_c,<PAD> /
   .endif` with auto-PAD = extent − trampoline(8|10). PoC
   `tools/luvdis_wrap.py` wrapped 97 functions in asm00_0.s; PAD matches by
   hand (sound_8000630: extent 18, 4-aligned → tramp 8 → PAD 10 ✓).

**Upshot:** this is Feature 5 ("stub ALL gates once, auto-PAD") falling out
of the disassembler — on clean uniform output, far easier than retrofitting
hand-edited asm. And it makes the disassembly **reproducible from ROM +
config** instead of depending on an un-reproducible IDA session.

## Gotchas found

- Luvdis needs `pkg_resources` → pin `setuptools<81` in its env.
- **Luvdis emits no `thumb_func_end`** — function end is implicit (next
  `thumb_func_start`). The wrap pass keys on the next-function boundary.
- GBA discovery is weak without seeding (no relocation metadata); the seed
  config is essential.

## Round-trip byte-match — TESTED, FAILED out of the box

Disassembled the whole code range (0x08000000–0x08150000) seeded with our
symbols + `--default-mode byte`, merged Luvdis's two output files,
assembled (agbasm, 0 errors), linked at 0x08000000 (defsym'd 27 external
RAM/folded symbols), objcopy'd to binary, compared to ROM[0:0x150000]:

- **NOT identical.** Output is **144 bytes larger**; first diff at byte 4.
- Byte 4+ is the **Nintendo logo (data)**, which Luvdis decoded as
  instructions — re-encoding produced different bytes. Data-as-code does
  not round-trip.
- ~90% of bytes differ, but most of that is **shift artifact** from the
  144-byte size drift, not genuinely-wrong content. The real faults are
  (1) mis-decoded data regions and (2) accumulated size/alignment drift.
- **Re-tested with `--no-guess` + complete seed + `--default-mode byte`
  (feed our function knowledge, suppress discovery): IDENTICAL failure** —
  same 144-byte growth, same byte-4 divergence, same 1,238,728 diffs.

**Can our existing knowledge fix it? No — Luvdis can't accept the half that
matters.** Its config expresses only functions
(`[arm_func|thumb_func] <addr>`); there is **no data-region annotation** —
no way to say "these bytes are data, don't decode them." The existing tree
knows both code AND data boundaries; Luvdis takes the code half and has
nowhere to put the data half, which is exactly what makes a disassembly
byte-exact. And feeding the full map would be circular anyway: the existing
`asm/` tree already *is* the byte-exact disassembly (builds to 0676ecd4) —
the knowledge that would make Luvdis correct is the knowledge that already
makes the current tree correct. No new information to gain.

**Conclusion: Luvdis is a strong disassembly _aid_, NOT a turnkey
byte-exact regenerator.** Its decoding of actual *code* is faithful
(sound_8000630 matched op-for-op), but a naive whole-ROM
disassemble→reassemble does not reproduce the cartridge. The thing that
makes a disassembly byte-exact is the **data / pointer-table / ARM-region
annotation** ("these bytes are data, don't decode them") — exactly the
manual work the original IDA+PseudoTerminal effort did over years, and
which Luvdis does NOT automate. "Reproducible from ROM + config" only holds
*after* you already own a correct code/data map — the hard part this repo
already paid for.

## Other gaps

- **PAD edge cases** the wrap PoC ignores but Feature 5 must handle: shared
  literal pools ([[09d]] concern), multi-entry funcs, ARM funcs,
  `non_word_aligned` starts.
- ~900 unresolved config addrs (nullsub_* are folded locals @ real ROM
  addresses the map hides; get them from the ELF, not the map).

## Recommendation (revised down)

Not the turnkey modernization first hoped. Realistic value is narrower:
- as a **second-opinion / re-disassembly aid** for the still-coarse
  `asmNN` files, cross-checked against the existing (already byte-exact)
  tree — NOT as a wholesale regenerator;
- the **auto-trampoline-wrap** idea ([[luvdis_wrap.py]]) is still good, but
  it should run on the *existing* matching asm (which already has the
  correct code/data boundaries), not on a fresh Luvdis dump.

Tools added: `tools/gen_luvdis_config.py`, `tools/luvdis_wrap.py` (PoC).
Round-trip scratch work in /tmp/rt (not committed).

---
_Last updated: 2026-05-31 12:26:26 -0400_
