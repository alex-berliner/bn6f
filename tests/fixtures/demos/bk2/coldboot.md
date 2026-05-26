# Generated from coldboot.bk2

- Frames: 417
- Source: BK2 (BizHawk)
- Savestate: skipped (--no-state)

## Header

```
MovieVersion BizHawk v2.0.0
Author default user
Core mGBA
Platform GBA
emuVersion Version 2.11.1
OriginalEmuVersion Version 2.11.1
GameName Mega Man Battle Network 6 - Cybeast Falzar (USA)
SHA1 0676ECD4D58A976AF3346CAEBB44B9B6489AD099
GBA_Firmware_Bios 300C20DF6731A33952DED8C436F7F186D25D3492
```

## Usage

The savestate loader in bn6f-track sniffs BizHawk-wrapped
states and strips the 4-byte header transparently, so you can
use the extracted `.ss` directly:

```
bn6f-track record bn6f.gba <frames> tools/function_symbols.txt \
    <out_dir> --input coldboot.input --state coldboot.ss \
    <addresses…>
```
