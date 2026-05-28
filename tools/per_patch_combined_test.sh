#!/usr/bin/env bash
# Combined-patch last-frame test.
#
# Enables N patches simultaneously (rather than one-at-a-time) and runs
# the last-frame PPM check. PASS = the patches compose correctly. FAIL
# = there's an interaction between some pair (or larger group) that
# per-patch testing won't catch.
#
# Usage:
#   bash tools/per_patch_combined_test.sh           # all validated (1-105 minus skips)
#   END=45 bash tools/per_patch_combined_test.sh    # patches 1..45
#   START=16 END=30 bash tools/per_patch_combined_test.sh  # subset
#
# SKIPS env var: comma-separated patch names to exclude (defaults to
# the known-fail list from issues/decomp-blockers.md #12).
set -u
cd "$(git rev-parse --show-toplevel)"

OUT=/tmp/per_patch_combined
mkdir -p "$OUT"
TRACK=tools/bn6f-track/target/release/bn6f-track

grep -hoE "\.ifndef DECOMP_\S+" asm/*.s | sed 's/.*DECOMP_//' | sort -u \
  > /tmp/m_canonical_$$.txt
TOTAL=$(wc -l < /tmp/m_canonical_$$.txt)
START="${START:-1}"
END="${END:-105}"
SKIPS="${SKIPS:-cutsceneCamera_focusCameraOnPlayerMaybe_8036faa}"

# Build skip set as awk-readable filter.
SKIP_FILTER=$(echo "$SKIPS" | tr ',' '|')

mapfile -t ENTRIES < <(awk -v s=$START -v e=$END -v skip="$SKIP_FILTER" '
  NR>=s && NR<=e {
    line=$0
    n=split(skip, sk, "|")
    keep=1
    for(i=1;i<=n;i++) if(line == sk[i]) { keep=0; break }
    if(keep) print line
  }' /tmp/m_canonical_$$.txt)
echo "Loaded ${#ENTRIES[@]} patches (positions $START-$END, skips: $SKIPS)"
echo "First: ${ENTRIES[0]}"
echo "Last:  ${ENTRIES[-1]}"

LIVE_ENTRIES=$(grep -cv "^#\|^$" tools/decomp_manifest.txt 2>/dev/null || echo 0)
if [ "$LIVE_ENTRIES" -lt 100 ]; then
    echo "ERROR: tools/decomp_manifest.txt only has $LIVE_ENTRIES entries — refusing" >&2
    exit 2
fi
BACKUP=/tmp/m_backup_combined_$$.txt
cp tools/decomp_manifest.txt "$BACKUP"
awk '/^#|^$/' "$BACKUP" > /tmp/m_header_combined_$$.txt
HEADER=/tmp/m_header_combined_$$.txt
echo "Backed up $LIVE_ENTRIES-entry manifest to $BACKUP"

trap 'cp "$BACKUP" tools/decomp_manifest.txt && touch tools/decomp_manifest.txt && rm -f "$BACKUP" "$HEADER" /tmp/m_canonical_$$.txt' EXIT INT TERM

echo
echo "=== prep: render orig last-frame PPMs (cached) ==="
make all -s >/dev/null </dev/null
cp -f build/bn6f.gba build/bn6f_orig.gba
declare -A ORIG_PPM
for bk2 in tests/fixtures/demos/bk2/*.bk2; do
  stem=$(basename "$bk2" .bk2)
  inp=tests/fixtures/demos/bk2/$stem.input
  ss=tests/fixtures/demos/bk2/$stem.ss
  ss_arg=""
  [ -s "$ss" ] && ss_arg="--state $ss"
  frames=$(($(stat -c%s "$inp") / 4))
  out=$OUT/orig__${stem}.ppm
  if ! [ -s "$out" ]; then
    printf "  [%s] %d frames..." "$stem" "$frames"
    $TRACK framebuf build/bn6f_orig.gba "$frames" "$out" --input "$inp" $ss_arg \
      > /dev/null 2>&1 </dev/null
    [ -s "$out" ] && printf " ok\n" || { echo " FAIL"; exit 1; }
  else
    printf "  [%s] cached (sha1=%s)\n" "$stem" "$(sha1sum "$out" | cut -c1-12)"
  fi
  ORIG_PPM[$stem]=$out
done

echo
echo "=== build decomp ROM with ${#ENTRIES[@]} patches enabled simultaneously ==="
cp "$HEADER" tools/decomp_manifest.txt
printf "%s\n" "${ENTRIES[@]}" >> tools/decomp_manifest.txt
touch tools/decomp_manifest.txt
make clean-conditional-objs >/dev/null 2>&1 </dev/null
make decompile -s >/dev/null 2>&1 </dev/null
cp -f build/bn6f.gba build/bn6f_decomp.gba
echo "decomp ROM md5: $(md5sum build/bn6f_decomp.gba | cut -c1-12)"

echo
echo "=== run last-frame check on each bk2 ==="
combined_verdict="PASS"
for bk2 in tests/fixtures/demos/bk2/*.bk2; do
  stem=$(basename "$bk2" .bk2)
  inp=tests/fixtures/demos/bk2/$stem.input
  ss=tests/fixtures/demos/bk2/$stem.ss
  ss_arg=""
  [ -s "$ss" ] && ss_arg="--state $ss"
  frames=$(($(stat -c%s "$inp") / 4))
  out=$OUT/decomp__${stem}.ppm
  printf "  [%s] %d frames..." "$stem" "$frames"
  $TRACK framebuf build/bn6f_decomp.gba "$frames" "$out" --input "$inp" $ss_arg \
    > /dev/null 2>&1 </dev/null
  if ! [ -s "$out" ]; then
    printf " no ppm\n"
    combined_verdict="FAIL"
    continue
  fi
  if cmp -s "${ORIG_PPM[$stem]}" "$out"; then
    printf " PASS\n"
  else
    orig_sha=$(sha1sum "${ORIG_PPM[$stem]}" | cut -c1-12)
    dec_sha=$(sha1sum "$out" | cut -c1-12)
    bytes_diff=$(cmp -l "${ORIG_PPM[$stem]}" "$out" 2>/dev/null | wc -l)
    printf " FAIL (orig=%s dec=%s diff=%dB)\n" "$orig_sha" "$dec_sha" "$bytes_diff"
    combined_verdict="FAIL"
  fi
done

echo
echo "=== combined verdict: $combined_verdict ==="
echo "Patches tested: ${#ENTRIES[@]}"
echo "Output PPMs: $OUT/"
