#!/usr/bin/env python3
"""Emit the authoritative function map: every `func_start` label joined to its
linked address.

The conversion surface is exactly the `thumb_func_start`/`arm_func_start`
labels in src/asm (count: 2751), not objdump's F-typed symbols (its flag
column is positionally unreliable). Addresses come from the linked symbol
table (`make syms` -> build/bn6f.sym, format: "<addr> <flag> <size> <name>").

Output (build/bn6f_functions.tsv), sorted by address:
    <addr_hex>\t<name>\t<isa>       isa in {thumb, arm}
"""
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ASM = os.path.join(ROOT, "src", "asm")
SYM = os.path.join(ROOT, "build", "bn6f.sym")
OUT = os.path.join(ROOT, "build", "bn6f_functions.tsv")

FUNC_RE = re.compile(r"^\s*(thumb|arm)_func_start\s+([A-Za-z_][A-Za-z0-9_]*)")


def collect_funcs():
    """name -> isa, from every .s under src/asm."""
    funcs = {}
    for dirpath, _, names in os.walk(ASM):
        for n in names:
            if not n.endswith(".s"):
                continue
            with open(os.path.join(dirpath, n), errors="replace") as f:
                for line in f:
                    m = FUNC_RE.match(line)
                    if m:
                        funcs[m.group(2)] = "thumb" if m.group(1) == "thumb" else "arm"
    return funcs


def load_addresses():
    """name -> address(int), from build/bn6f.sym."""
    addrs = {}
    with open(SYM, errors="replace") as f:
        for line in f:
            parts = line.split()
            if len(parts) >= 4:
                try:
                    addrs[parts[3]] = int(parts[0], 16)
                except ValueError:
                    pass
    return addrs


def main():
    if not os.path.exists(SYM):
        sys.exit(f"missing {SYM} — run `make syms` first")
    funcs = collect_funcs()
    addrs = load_addresses()

    rows, missing = [], []
    for name, isa in funcs.items():
        if name in addrs:
            rows.append((addrs[name], name, isa))
        else:
            missing.append(name)
    rows.sort()

    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    with open(OUT, "w") as f:
        for addr, name, isa in rows:
            f.write(f"{addr:08x}\t{name}\t{isa}\n")

    print(f"{len(rows)} functions -> {OUT}")
    if missing:
        print(f"WARNING: {len(missing)} func_start labels not in the symbol table:", file=sys.stderr)
        for name in missing[:20]:
            print(f"  {name}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
