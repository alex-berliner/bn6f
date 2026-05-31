#!/usr/bin/env python3
"""Render an SVG map of the ROM coloured by origin bucket.

Two panels:
  1. ROM address space (wrapped over several rows) binned by address;
     each bin is a stacked bar GENERATED / UNCERTAIN / HAND by line count.
  2. Per-file stacked bars (files ordered by start address).

Addresses come from build/bn6f.map (fallback: sub_<hex> names).
Output: build/origin_map.svg
"""

import re
import sys
from pathlib import Path
from collections import defaultdict
from PIL import Image, ImageDraw, ImageFont

sys.path.insert(0, str(Path(__file__).resolve().parent))
import classify_origin as C

ROOT = Path(__file__).resolve().parent.parent
MAP = ROOT / "build/bn6f.map"
OUT = ROOT / "build/origin_map.png"


def _font(size, bold=False):
    cands = [
        "/usr/share/fonts/truetype/dejavu/DejaVuSansMono-Bold.ttf" if bold
        else "/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf",
        "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
    ]
    for c in cands:
        try:
            return ImageFont.truetype(c, size)
        except OSError:
            continue
    return ImageFont.load_default()

COL = {"GENERATED": "#3a7d44", "UNCERTAIN": "#e0a93b", "HAND": "#d2473d"}
BG = "#0f1115"; FG = "#d7dadd"; GRID = "#2a2e35"

HEXNAME = re.compile(r"^sub_([0-9a-fA-F]+)$")


def load_addr():
    a = {}
    for line in MAP.read_text().splitlines():
        m = re.match(r"\s+0x(08[0-9a-fA-F]{6})\s+(\S+)\s*$", line)
        if m:
            a.setdefault(m.group(2), int(m.group(1), 16))
    return a


def collect():
    addr = load_addr()
    funcs = []  # (addr, bucket, lines, file)
    per_file = defaultdict(lambda: defaultdict(int))  # file -> bucket -> lines
    file_addr = {}
    for fname, name, is_arm, body, text in C.iter_functions():
        a = addr.get(name)
        if a is None:
            m = HEXNAME.match(name)
            a = int(m.group(1), 16) if m else None
        nlines = sum(1 for l in body if C.strip_comment(l).strip())
        bucket, _, _ = C.classify(is_arm, body, text)
        per_file[fname][bucket] += nlines
        if a is not None:
            funcs.append((a, bucket, nlines))
            file_addr[fname] = min(file_addr.get(fname, a), a)
    funcs.sort()
    ram = [f for f in funcs if f[0] < 0x08000000]
    rom = [f for f in funcs if f[0] >= 0x08000000]
    return rom, ram, per_file, file_addr


def main():
    funcs, ram, per_file, file_addr = collect()
    lo = 0x08000000
    hi = max(a for a, _, _ in funcs)
    span = hi - lo

    ROWS = 16
    BINS_PER_ROW = 240
    nbins = ROWS * BINS_PER_ROW
    binw = span / nbins
    bins = [defaultdict(float) for _ in range(nbins)]
    for a, bucket, nlines in funcs:
        idx = min(int((a - lo) / binw), nbins - 1)
        bins[idx][bucket] += nlines

    # layout
    W = 1180
    pad = 24
    track_x = 70
    track_w = W - track_x - pad
    bw = track_w / BINS_PER_ROW
    row_h = 26
    row_gap = 8
    top1 = 70
    panel1_h = ROWS * (row_h + row_gap)

    files = sorted(per_file.keys(), key=lambda f: file_addr.get(f, 1 << 30))
    bar_h = 13
    panel2_h = len(files) * (bar_h + 3) + 30
    total_h = int(top1 + panel1_h + 50 + panel2_h)

    img = Image.new("RGB", (W, total_h), BG)
    d = ImageDraw.Draw(img)
    f_title = _font(17, bold=True)
    f_h = _font(13, bold=True)
    f_sm = _font(11)
    f_tiny = _font(9)
    f_addr = _font(10)

    def R(x, y, w, h, fill):
        if w <= 0 or h <= 0:
            return
        d.rectangle([x, y, x + w, y + h], fill=fill)
    def T(x, y, s, font, fill=FG, anchor="la"):
        d.text((x, y), s, font=font, fill=fill, anchor=anchor)

    T(pad, 18, "ROM origin map — compiler-GENERATED vs UNCERTAIN vs HAND-written", f_title)
    ram_hand = sum(1 for _, b, _ in ram if b == "HAND")
    T(pad, 44, f"address bins, split by instruction-line share   "
               f"(+{len(ram)} RAM-resident funcs incl. ARM IRQ dispatcher, {ram_hand} HAND)",
      f_sm, "#9aa0a8")

    # legend
    lx = W - pad
    for name in ("HAND", "UNCERTAIN", "GENERATED"):
        T(lx, 44, name, f_sm, COL[name], anchor="ra")
        wlab = d.textlength(name, font=f_sm)
        R(lx - wlab - 16, 44, 10, 10, COL[name])
        lx -= wlab + 34

    # panel 1: wrapped address track
    binbins = bins
    for r in range(ROWS):
        y = top1 + r * (row_h + row_gap)
        row_lo = lo + int(r * BINS_PER_ROW * binw)
        T(track_x - 8, y + row_h / 2, f"{row_lo:07X}", f_addr, "#9aa0a8", anchor="rm")
        R(track_x, y, track_w, row_h, "#171a20")
        for b in range(BINS_PER_ROW):
            idx = r * BINS_PER_ROW + b
            bd = binbins[idx]
            tot = sum(bd.values())
            if tot == 0:
                continue
            x = track_x + b * bw
            yy = y
            for bucket in ("GENERATED", "UNCERTAIN", "HAND"):
                if bd[bucket] <= 0:
                    continue
                h = row_h * bd[bucket] / tot
                R(x, yy, bw + 0.6, h, COL[bucket])
                yy += h

    # panel 2: per-file stacked bars
    y2 = int(top1 + panel1_h + 40)
    T(pad, y2 - 22, "per-file composition (ordered by start address)", f_h)
    label_w = 150
    bar_x = pad + label_w
    bar_full = W - bar_x - pad - 70
    for i, fn in enumerate(files):
        fd = per_file[fn]
        tot = sum(fd.values())
        if tot == 0:
            continue
        yy = y2 + i * (bar_h + 3)
        T(bar_x - 6, yy + bar_h / 2, fn, f_addr, "#c7ccd1", anchor="rm")
        x = bar_x
        for bucket in ("GENERATED", "UNCERTAIN", "HAND"):
            w = bar_full * fd[bucket] / tot
            R(x, yy, w, bar_h, COL[bucket])
            x += w
        nz = fd["UNCERTAIN"] + fd["HAND"]
        T(bar_x + bar_full + 6, yy + bar_h / 2, f"{100*nz/tot:3.0f}% non-gen",
          f_tiny, "#9aa0a8", anchor="lm")

    img.save(OUT)
    print(f"wrote {OUT.relative_to(ROOT)}  ({len(files)} files, {len(funcs)} placed funcs, "
          f"range 0x{lo:08X}-0x{hi:08X})")


if __name__ == "__main__":
    main()
