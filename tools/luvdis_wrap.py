#!/usr/bin/env python3
"""PoC: wrap Luvdis-generated functions in DECOMP trampoline gates.

Demonstrates that, because Luvdis emits a uniform
  thumb_func_start NAME / NAME: @ <addr> / <body> / thumb_func_end NAME
shape and an address comment per function, we can inject the Feature-5
gate skeleton with auto-computed PAD at *generation* time — no retrofit of
hand-edited asm.

PAD = function_extent - trampoline_bytes, where:
  trampoline_bytes = 8 (4-aligned start) | 10 (2-aligned start)
  function_extent  = next_func_addr - this_func_addr  (covers body+pool)

Usage: tools/luvdis_wrap.py <luvdis_module.s> [next_module_first_addr_hex]
Writes wrapped output to stdout.
"""
import re
import sys

START = re.compile(r"^\s*(thumb_func_start|non_word_aligned_thumb_func_start|arm_func_start)\s+(\S+)")
ADDR = re.compile(r"^(\S+):\s*@\s*([0-9A-Fa-f]{8})")
END = re.compile(r"^\s*(thumb_func_end|arm_func_end)\s+(\S+)")


def tramp_bytes(addr):
    return 10 if (addr & 2) else 8


def main():
    path = sys.argv[1]
    lines = open(path).read().splitlines()

    # Luvdis emits no thumb_func_end — function end is implicit (the line
    # before the next thumb_func_start). Collect (name, addr, start_idx);
    # the body runs to the line before the next function's start.
    funcs = []
    for i, line in enumerate(lines):
        m = START.match(line)
        if not m:
            continue
        name = m.group(2)
        addr = None
        for j in range(i + 1, min(i + 3, len(lines))):
            am = ADDR.match(lines[j])
            if am and am.group(1) == name:
                addr = int(am.group(2), 16)
                break
        if addr is not None:
            funcs.append([name, addr, i])

    out = list(lines)
    inserts = []  # (start_idx, before_text, body_end_idx, after_text)
    for k, (name, addr, s) in enumerate(funcs):
        if k + 1 >= len(funcs):
            continue
        nxt_addr = funcs[k + 1][1]
        body_end = funcs[k + 1][2] - 1   # line before next func's start
        extent = nxt_addr - addr
        tb = tramp_bytes(addr)
        pad = extent - tb
        if pad < 0:
            continue
        before = f"\t.ifndef DECOMP_{name}"
        after = (
            f"\t.else\n"
            f"\tthumb_func_start {name}\n"
            f"{name}:\n"
            f"\tdecomp_trampoline {name}_c, {pad}\n"
            f"\tthumb_func_end {name}\n"
            f"\t.endif"
        )
        inserts.append((s, before, body_end, after))

    # Apply back-to-front so indices stay valid.
    for s, before, body_end, after in sorted(inserts, key=lambda t: -t[0]):
        out[body_end] = out[body_end] + "\n" + after
        out[s] = before + "\n" + out[s]

    sys.stdout.write("\n".join(out) + "\n")


if __name__ == "__main__":
    main()
