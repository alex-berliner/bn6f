#!/usr/bin/env bash
# Harness divergence canary.
#
# Verifies that bn6f-validate actually detects a failure when a patch
# really does diverge from orig. Without this, a silently-broken
# validator could report PASS across the board and we'd never know.
#
# Mechanism:
#   1. Save src/c/byte_fill.c
#   2. Replace it with tests/harness/byte_fill_BROKEN.c (XORs every
#      written byte with 0x01 — guaranteed visible divergence)
#   3. Run `bn6f-validate run --patch ByteFill`
#   4. Parse build/validate_results.csv and assert ALL bk2s say FAIL
#   5. Restore src/c/byte_fill.c (via git checkout — manifest-style
#      defense against trap-not-firing leaving the tree dirty)
#
# Exit 0 = harness correctly flagged the bad patch
# Exit 1 = harness did NOT flag it (validator is broken)
# Exit 2 = something else went wrong (build error, missing files, etc.)
#
# Not run on every CI invocation — runs as part of the full test
# suite (tests/run_all.sh).

set -u
cd "$(git rev-parse --show-toplevel)"

VALIDATE=tools/bn6f-validate/target/release/bn6f-validate
ORIG_C=src/c/byte_fill.c
BAD_C=tests/harness/byte_fill_BROKEN.c
CSV=build/validate_results.csv

if [ ! -x "$VALIDATE" ]; then
    echo "missing $VALIDATE — build with:" >&2
    echo "  (cd tools/bn6f-validate && cargo build --release)" >&2
    exit 2
fi
if [ ! -f "$BAD_C" ]; then
    echo "missing $BAD_C — canary source is gone" >&2
    exit 2
fi

cleanup() {
    git checkout -- "$ORIG_C" 2>/dev/null
    git checkout -- tools/decomp_manifest.txt 2>/dev/null
    touch tools/decomp_manifest.txt
}
trap cleanup EXIT INT TERM

echo "[canary] injecting broken ByteFill source"
cp "$BAD_C" "$ORIG_C"

VIDEO_FLAG=""
if [ "${WITH_VIDEOS:-0}" = "1" ]; then
    VIDEO_FLAG="--videos"
    echo "[canary] WITH_VIDEOS=1 — will also render mp4s under build/videos/"
fi

echo "[canary] running bn6f-validate run --patch ByteFill $VIDEO_FLAG"
"$VALIDATE" run --patch ByteFill -j 2 $VIDEO_FLAG > /tmp/canary.log 2>&1
rc=$?
if [ "$rc" -ne 0 ]; then
    echo "FAIL: validator exited non-zero ($rc) — likely a build error"
    cat /tmp/canary.log | tail -20
    exit 2
fi

if [ ! -f "$CSV" ]; then
    echo "FAIL: no $CSV produced"
    exit 2
fi

# Each bk2 row for the ByteFill patch must say FAIL. Anything else is
# either a harness regression or a real surprise about ByteFill.
echo "[canary] parsing $CSV"
# Skip header, take rows whose rom_stem ends in _ByteFill
mapfile -t rows < <(awk -F, 'NR>1 && $1 ~ /_ByteFill$/ { print $1","$2","$3 }' "$CSV")

if [ "${#rows[@]}" -eq 0 ]; then
    echo "FAIL: no ByteFill rows in CSV (parsing problem or job didn't run)"
    cat "$CSV"
    exit 2
fi

all_fail=yes
for row in "${rows[@]}"; do
    verdict=$(echo "$row" | cut -d, -f3)
    if [ "$verdict" != "FAIL" ]; then
        echo "  [canary] $row → expected FAIL got $verdict"
        all_fail=no
    else
        echo "  [canary] $row → FAIL ✓"
    fi
done

if [ "$all_fail" = "yes" ]; then
    echo
    echo "PASS: harness correctly detected the injected divergence on all bk2s"
    exit 0
else
    echo
    echo "FAIL: harness did NOT detect a known-bad ByteFill — validator is broken"
    exit 1
fi
