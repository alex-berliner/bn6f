#!/usr/bin/env bash
# Build per-bk2 invocation metadata.
#
# For each bk2 fixture, runs `bn6f-track track` against the orig ROM
# with the bk2's input + savestate, recording every function entered
# during playback. The hit list goes to:
#
#   tests/fixtures/demos/bk2/<stem>.hits.txt
#
# Format: same as bn6f-track track output —
#   header lines (commented)
#   "0xADDR  hits  calls  exits  name" per function
#
# Use the cross-reference script (`tools/patch_bk2_xref.sh`) to project
# this against the patch set and see which patches each bk2 exercises.
set -u
cd "$(git rev-parse --show-toplevel)"

TRACK=tools/bn6f-track/target/release/bn6f-track
SYMBOLS=tools/function_symbols.txt
if [ ! -s "$SYMBOLS" ]; then
  echo "Missing $SYMBOLS — generate it first."; exit 1
fi

echo "Building orig ROM..."
make all -s >/dev/null
ORIG_ROM=build/bn6f_orig.gba
cp -f build/bn6f.gba "$ORIG_ROM"

for bk2 in tests/fixtures/demos/bk2/*.bk2; do
  stem=$(basename "$bk2" .bk2)
  inp=tests/fixtures/demos/bk2/$stem.input
  ss=tests/fixtures/demos/bk2/$stem.ss
  out=tests/fixtures/demos/bk2/$stem.hits.txt
  state_arg=""
  [ -s "$ss" ] && state_arg="--state $ss"
  frames=$(($(stat -c%s "$inp") / 4))
  echo
  echo "=== $stem ($frames frames) ==="
  $TRACK track "$ORIG_ROM" "$frames" "$SYMBOLS" "$out" \
    --input "$inp" $state_arg
  echo "  → $out ($(grep -c "^0x" "$out") functions fired)"
done

echo
echo "Done. Hit lists at tests/fixtures/demos/bk2/*.hits.txt"
