#!/usr/bin/env bash
# bisect_visual.sh — bisect manifest prefix on framebuffer rendering.
#
# Usage:
#   tools/bisect_visual.sh <N>
#
# Builds the decomp ROM with the first N entries of tools/decomp_manifest.txt,
# renders frame 600, and prints the unique-byte count of the framebuffer.
# Exit 0 if graphics rendered (uniq > 5), exit 1 if blank (uniq <= 5).
#
# Use this to find which manifest entry breaks graphics. Same algorithm as
# the crash bisect — keep narrowing the prefix until N works and N+1 fails.
#
# Found the original LR-bit BX bug (decomp_lr_bit_bx_bug memory) and its
# 17-instance batch via this same loop.
set -e
N="$1"
[ -z "$N" ] && { echo "usage: $0 <N>" >&2; exit 2; }

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

MANIFEST="tools/decomp_manifest.txt"
ENTRIES="/tmp/manifest_entries.txt"

# Cache the full unfiltered entries list (skip if exists).
grep -v "^#" "$MANIFEST" | grep -v "^$" > "$ENTRIES.full"
[ ! -f "$ENTRIES" ] && cp "$ENTRIES.full" "$ENTRIES"

awk '/^#|^$/' "$MANIFEST" > /tmp/m_test.txt
head -n "$N" "$ENTRIES" >> /tmp/m_test.txt
cp "$MANIFEST" /tmp/m_orig.txt
cp /tmp/m_test.txt "$MANIFEST"

trap "cp /tmp/m_orig.txt $MANIFEST" EXIT

make clean-conditional-objs >/dev/null 2>&1
rm -f bn6f.elf bn6f.gba
make decompile -s >/dev/null 2>&1
cp bn6f.gba build/bn6f_decomp.gba

tools/bn6f-track/target/release/bn6f-track framebuf \
    build/bn6f_decomp.gba 600 /tmp/bisect.ppm > /dev/null 2>&1

UNIQ=$(python3 -c "
with open('/tmp/bisect.ppm','rb') as f:
    hdr=b''
    while not hdr.endswith(b'255\n'): hdr += f.read(1)
    data = f.read()
print(len(set(data)))
")
echo "n=$N uniq_bytes=$UNIQ"
[ "$UNIQ" -gt 5 ]
