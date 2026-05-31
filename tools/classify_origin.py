#!/usr/bin/env python3
"""Heuristic: which ASM functions look compiler-GENERATED vs HAND-written.

This is a *rough* triage to estimate the compiled/hand split across the
ROM, not a precise classifier. It cannot be precise: the original game's
compiler (agbcc / old GCC) itself emits interworking idioms
(`mov lr,pc; bx rN`) and the game holds ambient pointers in r10/r5, so
the signals that flag hand-code in a normal codebase are baked into this
compiler's *normal* output here. We therefore key only on signals that
calibration showed are genuinely rare (see SIGNALS below), and report a
large "looks generated" bulk with an honest "uncertain" middle.

Usage: tools/classify_origin.py [--list] [--by-file]
  --list     also print the functions flagged HAND-written
  --by-file  also print per-file handwritten density

Reads asm/*.s directly (no build artifact needed). Analyzes each
function's ORIGINAL body; trampoline `.else` stand-ins are skipped.
"""

import re
import sys
from pathlib import Path
from collections import defaultdict

ROOT = Path(__file__).resolve().parent.parent
ASM_DIR = ROOT / "asm"

START_RE = re.compile(r"^\s*(thumb_func_start|arm_func_start|thumb_local_start)\b(?:\s+(\S+))?")
END_RE = re.compile(r"^\s*(thumb_func_end|arm_func_end)\b")
LABEL_RE = re.compile(r"^([A-Za-z_.][\w.]*):")

# --- signal regexes, applied to comment-stripped body text ---
# STRONG: rare in calibration → near-certain hand / system code.
# NB: signals that calibration proved NON-discriminating here are
# deliberately excluded: `svc N` (BIOS call, e.g. division — appears in
# ordinary code), and r8/r9/r10 usage (agbcc freely uses high registers,
# and the game holds ambient globals in them).
S_SYSREG = re.compile(r"\b(mrs|msr)\b")
S_COPROC = re.compile(r"\b(mcr|mrc|mcrr|mrrc|cps)\b")  # true coprocessor ops only
S_ARMBLK = re.compile(r"\b(stmfd|stmdb|ldmfd|ldmdb|stmed|ldmed)\b")  # ARM full/empty-descending (not thumb stmia/ldmia)
S_FP     = re.compile(r"\b(fp|r11)\b")  # frame pointer — agbcc Thumb doesn't emit it
S_MOVPC  = re.compile(r"\bmov\s+pc,\s*(?!lr\b)r\d")  # computed jump (not `mov pc,lr` return)
# GENERATED evidence: standard frame.
G_PUSH = re.compile(r"\bpush\s*\{[^}]*\blr\b")
G_POP  = re.compile(r"\bpop\s*\{[^}]*\bpc\b")
G_RET  = re.compile(r"\bbx\s+lr\b|\bpop\s*\{[^}]*\bpc\b|\bmov\s+pc,\s*lr\b")
HAS_BL = re.compile(r"\bbl\s+\w")


def strip_comment(line):
    for marker in ("//", "/*", "@"):
        i = line.find(marker)
        if i != -1:
            line = line[:i]
    return line


def iter_functions():
    """Yield (file, name, is_arm, body_lines). Skips trampoline stand-ins."""
    for s_file in sorted(ASM_DIR.glob("*.s")):
        raw = s_file.read_text().splitlines()
        i, n = 0, len(raw)
        while i < n:
            m = START_RE.match(raw[i])
            if not m:
                i += 1
                continue
            is_arm = m.group(1) == "arm_func_start"
            name = m.group(2)
            j = i + 1
            body = []
            while j < n and not END_RE.match(raw[j]):
                if name is None:
                    lm = LABEL_RE.match(raw[j])
                    if lm:
                        name = lm.group(1)
                body.append(raw[j])
                j += 1
            text = "\n".join(strip_comment(l) for l in body)
            if "decomp_trampoline" not in text:  # skip .else stand-ins
                yield s_file.name, (name or "?"), is_arm, body, text
            i = j + 1


def classify(is_arm, body, text):
    strong = []
    if is_arm:                strong.append("arm-mode")
    if S_SYSREG.search(text): strong.append("mrs/msr")
    if S_COPROC.search(text): strong.append("coproc/swi")
    if S_ARMBLK.search(text): strong.append("arm-stack")
    if S_FP.search(text):     strong.append("fp/r11")
    if S_MOVPC.search(text):  strong.append("computed-mov-pc")

    medium = []
    # call without saving lr = unusual (tail-call glue / hand fragment)
    if HAS_BL.search(text) and not G_PUSH.search(text):
        medium.append("bl-without-push-lr")

    has_frame = bool(G_PUSH.search(text) and G_POP.search(text))
    clean_leaf = bool(G_RET.search(text)) and not strong and not medium

    if strong:
        return "HAND", strong, medium
    if medium:
        return "UNCERTAIN", strong, medium
    if has_frame or clean_leaf:
        return "GENERATED", strong, medium
    return "UNCERTAIN", strong, medium


def main():
    show_list = "--list" in sys.argv
    by_file = "--by-file" in sys.argv

    buckets = {"GENERATED": 0, "HAND": 0, "UNCERTAIN": 0}
    lines_b = {"GENERATED": 0, "HAND": 0, "UNCERTAIN": 0}
    signal_hits = defaultdict(int)
    hand_funcs = []
    file_hand = defaultdict(lambda: [0, 0])  # file -> [hand, total]

    total = 0
    for fname, name, is_arm, body, text in iter_functions():
        total += 1
        nlines = sum(1 for l in body if strip_comment(l).strip())
        cls, strong, medium = classify(is_arm, body, text)
        buckets[cls] += 1
        lines_b[cls] += nlines
        for s in strong + medium:
            signal_hits[s] += 1
        file_hand[fname][1] += 1
        if cls == "HAND":
            file_hand[fname][0] += 1
            hand_funcs.append((fname, name, nlines, strong + medium))

    tl = sum(lines_b.values())
    print(f"Analyzed {total} functions ({tl} instruction lines) across asm/*.s\n")
    print(f"{'bucket':<11} {'funcs':>7} {'pct':>6}   {'lines':>8} {'pct':>6}")
    for b in ("GENERATED", "UNCERTAIN", "HAND"):
        fp = 100 * buckets[b] / total if total else 0
        lp = 100 * lines_b[b] / tl if tl else 0
        print(f"{b:<11} {buckets[b]:>7} {fp:>5.1f}%   {lines_b[b]:>8} {lp:>5.1f}%")

    print("\nSignal frequency (functions hit):")
    for s, c in sorted(signal_hits.items(), key=lambda kv: -kv[1]):
        print(f"  {s:<22} {c}")

    if by_file:
        print("\nTop files by hand-written density (>=3 hand funcs):")
        rows = [(h / t, h, t, f) for f, (h, t) in file_hand.items() if h >= 3]
        for dens, h, t, f in sorted(rows, reverse=True)[:25]:
            print(f"  {f:<24} {h:>4}/{t:<4} {100*dens:>5.1f}%")

    if show_list:
        print(f"\nHAND-flagged functions ({len(hand_funcs)}):")
        for fname, name, nlines, sigs in sorted(hand_funcs, key=lambda r: -r[2]):
            print(f"  {fname:<22} {name:<28} {nlines:>4}L  {','.join(sigs)}")


if __name__ == "__main__":
    main()
