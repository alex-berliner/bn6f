#!/usr/bin/env bash
# Per-patch video pipeline.
#
# For each of the first 15 alphabetic patches:
#   - build decomp ROM with ONLY that patch enabled
#   - render orig + decomp videos for each bk2 fixture
#   - place in build/videos/<patch>/<bk2>__{orig,decomp}.mp4 (4x speed, no audio)
#
# Orig videos are rendered once and symlinked into each patch dir.
set -u
cd "$(git rev-parse --show-toplevel)"

OUT=build/videos
mkdir -p "$OUT/_base"
TRACK=tools/bn6f-track/target/release/bn6f-track

# Patch set — every `.ifndef DECOMP_<sym>` in asm/*.s, first 15 alphabetic.
grep -hoE "\.ifndef DECOMP_\S+" asm/*.s | sed 's/.*DECOMP_//' | sort -u \
  > /tmp/m_canonical_$$.txt
mapfile -t ENTRIES < <(head -15 /tmp/m_canonical_$$.txt)
echo "Loaded ${#ENTRIES[@]} patches: ${ENTRIES[0]} ... ${ENTRIES[-1]}"

LIVE_ENTRIES=$(grep -cv "^#\|^$" tools/decomp_manifest.txt 2>/dev/null || echo 0)
if [ "$LIVE_ENTRIES" -lt 100 ]; then
    echo "ERROR: tools/decomp_manifest.txt has only $LIVE_ENTRIES entries — refusing" >&2
    exit 2
fi
BACKUP=/tmp/m_backup_$$.txt
cp tools/decomp_manifest.txt "$BACKUP"
awk '/^#|^$/' "$BACKUP" > /tmp/m_header_$$.txt
HEADER=/tmp/m_header_$$.txt
echo "Backed up $LIVE_ENTRIES-entry manifest to $BACKUP"

trap 'cp "$BACKUP" tools/decomp_manifest.txt && touch tools/decomp_manifest.txt && rm -f "$BACKUP" "$HEADER" /tmp/m_canonical_$$.txt' EXIT INT TERM

render() {
  # Direct recvideo output, no ffmpeg post-process. Use `ffplay -vf
  # "setpts=PTS/4"` at view time for 4x review playback.
  local rom=$1 frames=$2 inp=$3 ss_arg=$4 out=$5
  $TRACK recvideo "$rom" "$frames" "$out" --input "$inp" $ss_arg \
    > /dev/null 2>&1 </dev/null
}

echo
echo "=== prep: build orig ROM, render orig videos once ==="
make all -s >/dev/null </dev/null
cp -f build/bn6f.gba build/bn6f_orig.gba

for bk2 in tests/fixtures/demos/bk2/*.bk2; do
  stem=$(basename "$bk2" .bk2)
  inp=tests/fixtures/demos/bk2/$stem.input
  ss=tests/fixtures/demos/bk2/$stem.ss
  ss_arg=""
  [ -s "$ss" ] && ss_arg="--state $ss"
  frames=$(($(stat -c%s "$inp") / 4))
  out=$OUT/_base/${stem}__orig.mp4
  if [ -s "$out" ]; then
    printf "  [orig/%s] cached (%s bytes)\n" "$stem" "$(stat -c%s "$out")"
  else
    printf "  [orig/%s] %d frames..." "$stem" "$frames"
    if render build/bn6f_orig.gba "$frames" "$inp" "$ss_arg" "$out"; then
      printf " %s bytes\n" "$(stat -c%s "$out")"
    else
      printf " FAIL\n"
    fi
  fi
done

echo
echo "=== phase 1: pre-build ${#ENTRIES[@]} per-patch decomp ROMs sequentially ==="
ROM_DIR=/tmp/per_patch_roms_$$
mkdir -p "$ROM_DIR"
for fn in "${ENTRIES[@]}"; do
  outdir=$OUT/$fn
  mkdir -p "$outdir"
  for bk2 in tests/fixtures/demos/bk2/*.bk2; do
    stem=$(basename "$bk2" .bk2)
    ln -sf "../_base/${stem}__orig.mp4" "$outdir/${stem}__orig.mp4"
  done
  rom_out=$ROM_DIR/bn6f_${fn}.gba
  printf "  building decomp ROM for %-40s " "$fn"
  cp "$HEADER" tools/decomp_manifest.txt
  echo "$fn" >> tools/decomp_manifest.txt
  touch tools/decomp_manifest.txt
  make clean-conditional-objs >/dev/null 2>&1 </dev/null
  make decompile -s >/dev/null 2>&1 </dev/null
  cp -f build/bn6f.gba "$rom_out"
  echo "ok"
done

echo
echo "=== phase 2: render 45 decomp videos in parallel ==="
PARALLEL=${PARALLEL:-$(nproc)}
PARALLEL=$((PARALLEL > 6 ? 6 : PARALLEL))   # cap — x264 already multi-threads
echo "using $PARALLEL workers"
# Build the job list: rom path | bk2 stem | frames | input | state | output
JOBS=/tmp/per_patch_jobs_$$.txt
: > "$JOBS"
for fn in "${ENTRIES[@]}"; do
  for bk2 in tests/fixtures/demos/bk2/*.bk2; do
    stem=$(basename "$bk2" .bk2)
    inp=tests/fixtures/demos/bk2/$stem.input
    ss=tests/fixtures/demos/bk2/$stem.ss
    frames=$(($(stat -c%s "$inp") / 4))
    out=$OUT/$fn/${stem}__decomp.mp4
    rom=$ROM_DIR/bn6f_${fn}.gba
    echo "$rom|$frames|$inp|$ss|$out|$fn|$stem" >> "$JOBS"
  done
done
total=$(wc -l < "$JOBS"); echo "$total jobs queued"

# Worker fn for xargs
export TRACK
run_job() {
  IFS='|' read -r rom frames inp ss out fn stem <<< "$1"
  ss_arg=""
  [ -s "$ss" ] && ss_arg="--state $ss"
  $TRACK recvideo "$rom" "$frames" "$out" --input "$inp" $ss_arg \
    > /dev/null 2>&1 </dev/null
  if [ -s "$out" ]; then
    printf "  ok  [%-32s][%s] %s bytes\n" "$fn" "$stem" "$(stat -c%s "$out")"
  else
    printf "  FAIL [%-32s][%s]\n" "$fn" "$stem"
  fi
}
export -f run_job
xargs -d '\n' -P "$PARALLEL" -I {} bash -c 'run_job "$@"' _ {} < "$JOBS"
rm -rf "$ROM_DIR" "$JOBS"

echo
echo "=== done. videos at $OUT/<patch>/ ==="
ls -d $OUT/*/ | grep -v _base | head -20
