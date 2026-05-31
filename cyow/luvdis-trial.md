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

## Open / not yet proven (the real gate)

- **Round-trip byte-match.** Not yet confirmed the Luvdis output *assembles
  to the identical ROM*. That's the decisive test — regenerate one module,
  build `make all` (no DECOMP defined), require sha 0676ecd4. Cosmetic
  diffs (pool-label names, literal symbolication) must not change emitted
  bytes; needs the repo's macro/symbol conventions reconciled with
  Luvdis's.
- **PAD edge cases** the PoC ignores but Feature 5 must handle: shared
  literal pools ([[09d]] concern), multi-entry funcs, ARM funcs,
  `non_word_aligned` starts. Same concerns list already recorded for
  Feature 5.
- Clean the ~900 unresolved config addrs (nullsub_* map artifacts).

## Recommendation

Promising enough to pursue as the modernization path for Features 5 + the
split's reproducibility. Next concrete step: prove the round-trip byte-match
on a single module before committing to a full regeneration.

Tools added: `tools/gen_luvdis_config.py`, `tools/luvdis_wrap.py` (PoC).

---
_Last updated: 2026-05-31 11:53:41 -0400_
