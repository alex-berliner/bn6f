#!/usr/bin/env python3
"""Resolve an address to its nearest symbol + offset.

Reads `nm --numeric-sort` output on stdin and the target address as
argv[1]. Prints `<symbol>+0x<offset>` (or `?+0x...` if no symbol
precedes the address). Used by `make verify-strict` to map a
divergent PC to its containing C function.
"""
import sys

target = int(sys.argv[1], 16)
last_addr, last_name = 0, "?"
for line in sys.stdin:
    parts = line.split()
    if len(parts) < 3:
        continue
    # nm --numeric-sort output: <addr> <type> <name>
    # Type is one letter; capital = global, lowercase = local. We want
    # the nearest *function* symbol — usually 'T' (text, global) or 't'
    # (text, local). Skip noise markers like '.gcc2_compiled.' (local
    # marker at C file start) and data symbols.
    sym_type = parts[1]
    name = parts[2]
    if sym_type not in ("T", "t"):
        continue
    if name.startswith("."):
        continue
    try:
        addr = int(parts[0], 16)
    except ValueError:
        continue
    if addr > target:
        break
    last_addr, last_name = addr, name

print(f"{last_name}+0x{target - last_addr:x}")
