# bk2 validation fixtures

`bn6f-validate` (see
[../../../tools/bn6f-validate/README.md](../../../tools/bn6f-validate/README.md))
replays the BizHawk `.bk2` movies under `bk2/` through both the orig and
each patched ROM, then compares per-frame framebuffer hashes. These
movies are the single source of truth — there are no pre-extracted
`.input` or `.ss` derivatives; the validator reads each `.bk2` zip
directly.

## Layout

```
tests/fixtures/demos/bk2/
    fixtures.json              catalog: name, file, description,
                               starts_from_savestate (+ ROM/BIOS sha1)
    coldboot.bk2               ~417 frames, zero input, no savestate
    intro.bk2                  ~6.2k frames, from savestate
    intro_to_end_tutorial.bk2  ~16.4k frames, from savestate
```

Each `.bk2` is a self-contained zip holding `Input Log.txt` (per-frame
button bitmap) and, when the recording started mid-game, `Core.bin.zst`
(a zstd-compressed BizHawk-wrapped mGBA savestate). Frame count, ROM
sha1, and BIOS sha1 live inside the `.bk2`'s own `Header.txt`, so they
aren't duplicated in `fixtures.json` and can't drift.

## Adding a fixture

1. Record gameplay in BizHawk (GBA core, ROM matching `bn6f.sha1`) and
   save the movie as `<name>.bk2`.
2. Drop it in `bk2/`.
3. Add a catalog entry to `fixtures.json` (`name`, `file`,
   `description`, `starts_from_savestate`).
4. `bn6f-validate run` picks it up automatically — every fixture is
   replayed against every selected patch.

Prefer fixtures that exercise distinct code paths (boot/init, menus,
battle, overworld, dialogue) — a patch only gets coverage on the frames
a fixture actually reaches.

---
_Last updated: 2026-05-29 12:49:32 -0400_
