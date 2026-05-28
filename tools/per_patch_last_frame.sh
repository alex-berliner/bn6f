#!/usr/bin/env bash
# Per-patch last-frame visual verification.
#
# For each of the first 15 alphabetic patches, enable ONLY that patch,
# build the decomp ROM, render the last frame of each bk2 fixture, and
# compare the PPM byte-for-byte against the orig's last frame. A patch
# passes iff every bk2's final frame matches orig exactly.
#
# This is a *visual* correctness check independent of per-frame lockstep
# (which is over-strict due to trampoline cycle drift). If the screen
# shows the same end state, the patch is functionally good for that
# bk2 — drift-class state divergences that don't affect visible output
# are tolerated.
set -u
cd "$(git rev-parse --show-toplevel)"

OUT=/tmp/per_patch_last_frame
mkdir -p "$OUT"
TRACK=tools/bn6f-track/target/release/bn6f-track

# Source of truth for the patchable function set: every `.ifndef
# DECOMP_<sym>` in asm/*.s. Same convention as per_patch_videos.sh.
grep -hoE "\.ifndef DECOMP_\S+" asm/*.s | sed 's/.*DECOMP_//' | sort -u \
  > /tmp/m_canonical_$$.txt
mapfile -t ENTRIES < <(head -15 /tmp/m_canonical_$$.txt)
echo "Loaded ${#ENTRIES[@]} patches: ${ENTRIES[0]} ... ${ENTRIES[-1]}"

# Backup defensively (sanity-check live manifest isn't a partial stub).
LIVE_ENTRIES=$(grep -cv "^#\|^$" tools/decomp_manifest.txt 2>/dev/null || echo 0)
if [ "$LIVE_ENTRIES" -lt 100 ]; then
    echo "ERROR: tools/decomp_manifest.txt has only $LIVE_ENTRIES entries — refusing"
    echo "       to back up a stub. Restore manifest and rerun." >&2
    exit 2
fi
BACKUP=/tmp/m_backup_$$.txt
cp tools/decomp_manifest.txt "$BACKUP"
awk '/^#|^$/' "$BACKUP" > /tmp/m_header_$$.txt
HEADER=/tmp/m_header_$$.txt
echo "Backed up $LIVE_ENTRIES-entry manifest to $BACKUP"

trap 'cp "$BACKUP" tools/decomp_manifest.txt && touch tools/decomp_manifest.txt && rm -f "$BACKUP" "$HEADER" /tmp/m_canonical_$$.txt' EXIT INT TERM

echo
echo "=== prep: build orig ROM, render orig last frames per bk2 ==="
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
  printf "  [%s] %d frames -> orig last-frame ppm... " "$stem" "$frames"
  $TRACK framebuf build/bn6f_orig.gba "$frames" "$out" --input "$inp" $ss_arg \
    > /dev/null 2>&1 </dev/null
  if [ -s "$out" ]; then
    sha=$(sha1sum "$out" | cut -c1-12)
    echo "ok ($(stat -c%s "$out") bytes, sha1=$sha)"
    ORIG_PPM[$stem]=$out
  else
    echo "FAIL"
    exit 1
  fi
done

echo
echo "=== per-patch: ${#ENTRIES[@]} patches ==="
printf -- "%s\n" "------------------------------------------------------------"
printf "%-32s  %-9s  %s\n" "patch" "verdict" "details"
printf -- "%s\n" "------------------------------------------------------------"

for fn in "${ENTRIES[@]}"; do
  # Manifest with just this one patch
  cp "$HEADER" tools/decomp_manifest.txt
  echo "$fn" >> tools/decomp_manifest.txt
  touch tools/decomp_manifest.txt
  make clean-conditional-objs >/dev/null 2>&1 </dev/null
  make decompile -s >/dev/null 2>&1 </dev/null
  cp -f build/bn6f.gba build/bn6f_decomp.gba

  patch_verdict="PASS"
  fail_details=""
  for bk2 in tests/fixtures/demos/bk2/*.bk2; do
    stem=$(basename "$bk2" .bk2)
    inp=tests/fixtures/demos/bk2/$stem.input
    ss=tests/fixtures/demos/bk2/$stem.ss
    ss_arg=""
    [ -s "$ss" ] && ss_arg="--state $ss"
    frames=$(($(stat -c%s "$inp") / 4))
    decomp_ppm=$OUT/${fn}__${stem}.ppm
    $TRACK framebuf build/bn6f_decomp.gba "$frames" "$decomp_ppm" \
      --input "$inp" $ss_arg > /dev/null 2>&1 </dev/null
    if ! [ -s "$decomp_ppm" ]; then
      patch_verdict="FAIL"
      fail_details="[$stem] no ppm produced; ${fail_details}"
      continue
    fi
    if ! cmp -s "${ORIG_PPM[$stem]}" "$decomp_ppm"; then
      patch_verdict="FAIL"
      orig_sha=$(sha1sum "${ORIG_PPM[$stem]}" | cut -c1-12)
      dec_sha=$(sha1sum "$decomp_ppm" | cut -c1-12)
      # Count differing bytes (excluding the 16-byte PPM header)
      bytes_diff=$(cmp -l "${ORIG_PPM[$stem]}" "$decomp_ppm" 2>/dev/null | wc -l)
      fail_details="[$stem] orig=$orig_sha dec=$dec_sha diff=${bytes_diff}B; ${fail_details}"
    fi
  done

  printf "%-32s  %-9s  %s\n" "$fn" "$patch_verdict" "$fail_details"
done

echo
echo "=== done. ppms at $OUT/ ==="
