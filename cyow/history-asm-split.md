# History — how the ASM was originally split (git scan)

From a scan of repo history (2018 → present). Answers: what tool, how were
files split, did they think in translation units?

## Tool: IDA Pro + GBA-IDA-Pseudo-Terminal ("PT")

Disassembly was **driven from IDA Pro**, not hand-typed, via LanHikari22's
**GBA-IDA-Pseudo-Terminal** framework
(`github.com/LanHikari22/GBA-IDA-Pseudo-Terminal`). Workflow (first-commit
INSTALL.md):
- load ROM into IDA as ARM LE @ 0x08000000, run a game-loader idc;
- `pt.dis.push()` disassembles + exports all code files;
- `pt.dis.extract()` extracts the binary blobs.

Repo glue: `tools/fix_idb.py` (force-Thumb, strip IDA's bad ARM guesses,
remove fake red code), `tools/pt_env_bn6f.py` (the file/address map),
`tools/fdiff.py` (ROM diff), `tools/gen_obj_tail.py` (the tail blob).
Started **July 2018**, author "Lan."

## Split method: manual address ranges, carved by recognition

The PT env script held a `gameFiles` dict mapping filename → (start, end):
```python
'start.s': (0x8000000, 0x80002BC),
'main.s':  (0x80002BC, 0x80005AC),
# 'asm00.s': (0x8000550, 0x8017C08),   # a giant coarse chunk
```
They began with a few **coarse "code chunk files"** spanning huge ranges,
then progressively **carved named modules out of them as subsystems were
recognized** (commits literally: "identified chatbox.s"). Hence today's
mix of recognized names (`chatbox.s`, `sprite.s`, `npc.s`, `ow_player.s`)
beside still-coarse leftovers (`asm31.s`).

Checksum-locked throughout: undisassembled bytes lived in a raw `tail.bin`
(`make tail`), and `make checksum` / `make fdiff` enforced a bit-identical
rebuild as the tail shrank ("disassembled X%" commits track progress).

## Translation units: TU-shaped, but human-drawn

They never wrote "translation unit" (said "modules" / "game files"), but
the model is explicitly TU-like — CONTRIBUTE.md:

> "Every asm file is associated with a header file in the `inc` folder,
> which defines its public symbols, and all external symbols it uses."

That's a TU interface: per-file exports + imports. **But the boundaries
were chosen by human reverse-engineering**, drawn where a subsystem was
understood — NOT recovered from the original compiler's TU fingerprints.
So the file split is a deliberately TU-shaped, hand-curated approximation,
not a reconstruction of the original `.c` boundaries. (Confirms the
inference in [origin-classification](origin-classification.md) — the named
files are recovered subsystems, not recovered compilation units.)

## Curio

The first commit's README still said "RockMan EXE 4: Tournament Red Sun"
while the env script was already `pt_env_bn6f.py` — the whole IDA+PT
methodology was **inherited from Lan's earlier EXE4 disassembly** and
aimed at BN6 from day one; the README just wasn't updated until later.

---
_Last updated: 2026-05-31 11:39:13 -0400_
