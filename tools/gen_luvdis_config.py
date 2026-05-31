#!/usr/bin/env python3
"""Emit a Luvdis function config from the existing disassembly.

Each line: `[thumb_func|arm_func] <addr> <module> <name>` — which lets
Luvdis reproduce the current file split (module) and symbol names while
re-disassembling from the ROM. Addresses come from build/bn6f.map.

Usage: tools/gen_luvdis_config.py > build/bn6_funcs.cfg
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
ASM = ROOT / "asm"
MAP = ROOT / "build/bn6f.map"

START = re.compile(r"^\s*(thumb_func_start|arm_func_start|thumb_local_start)\b(?:\s+(\S+))?")
LAB = re.compile(r"^([A-Za-z_.][\w.]*):")
HEX = re.compile(r"^(?:sub|loc|nullsub|off)_([0-9A-Fa-f]+)$")


def load_addr():
    a = {}
    for line in MAP.read_text().splitlines():
        m = re.match(r"\s+0x(0[0-9a-fA-F]{7})\s+(\S+)\s*$", line)
        if m:
            a.setdefault(m.group(2), int(m.group(1), 16))
    return a


def main():
    addr = load_addr()
    out, miss = [], 0
    for s_file in sorted(ASM.glob("*.s")):
        module = s_file.name
        lines = s_file.read_text().splitlines()
        for i, line in enumerate(lines):
            m = START.match(line)
            if not m:
                continue
            mode = "arm_func" if m.group(1) == "arm_func_start" else "thumb_func"
            name = m.group(2)
            if name is None:  # thumb_local_start: name on next label line
                for j in range(i + 1, min(i + 4, len(lines))):
                    lm = LAB.match(lines[j])
                    if lm:
                        name = lm.group(1)
                        break
            if not name:
                continue
            a = addr.get(name)
            if a is None:
                hm = HEX.match(name)
                a = int(hm.group(1), 16) if hm else None
            if a is None:
                miss += 1
                continue
            out.append((a, mode, module, name))
    out.sort()
    print("# Luvdis config generated from existing asm/*.s + bn6f.map")
    print("# [arm_func|thumb_func] <address> [module] [name]")
    for a, mode, module, name in out:
        print(f"{mode} 0x{a:07X} {module} {name}")
    print(f"# {len(out)} functions emitted, {miss} unresolved", file=sys.stderr)


if __name__ == "__main__":
    main()
