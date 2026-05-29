#!/usr/bin/env bash
# Harness divergence canary.
#
# Verifies that bn6f-validate actually detects a failure when a patch
# really does diverge from orig. Without this, a silently-broken
# validator could report PASS across the board and we'd never know.
#
# How it works:
#   - There's a static canary patch called `ByteFillCanary` that lives
#     permanently in the source tree:
#       asm/asm00_0.s     — `.ifdef DECOMP_ByteFillCanary` trampoline
#                           branch that redirects ByteFill's slot
#       src/c/byte_fill_canary.c — broken ByteFill_c that XORs every
#                                  written byte with 0x01
#   - It is NOT a real patch (uses `.ifdef`, not `.ifndef`) so it
#     doesn't appear in the alphabetic patch list.
#   - In the validator it lives at canary index 7_000_001, so all of
#     its build artifacts (ROM / hashes / videos) end up under
#     `build/...0000001_ByteFill...` for the REAL patch and
#     `build/...7000001_ByteFillCanary...` for the canary. No
#     collisions with real-patch outputs.
#
# This script just runs the validator against the canary patch and
# asserts FAIL on every bk2. No source modification, no stash/restore
# dance, no risk of leaving the tree dirty.
#
# Exit 0 = harness correctly flagged the canary
# Exit 1 = harness did NOT flag it (validator is broken)
# Exit 2 = something else went wrong (build error, missing files, etc.)
#
# Env vars:
#   WITH_VIDEOS=1   also render mp4s under build/videos/7000001_ByteFillCanary/

set -u
cd "$(git rev-parse --show-toplevel)"

VALIDATE=tools/bn6f-validate/target/release/bn6f-validate
CSV=build/validate_results.csv

if [ ! -x "$VALIDATE" ]; then
    echo "missing $VALIDATE — build with:" >&2
    echo "  (cd tools/bn6f-validate && cargo build --release)" >&2
    exit 2
fi

VIDEO_FLAG=""
if [ "${WITH_VIDEOS:-0}" = "1" ]; then
    VIDEO_FLAG="--videos"
    echo "[canary] WITH_VIDEOS=1 — will also render mp4s under build/videos/7000001_ByteFillCanary/"
fi

echo "[canary] running bn6f-validate run --patch ByteFillCanary $VIDEO_FLAG"
"$VALIDATE" run --patch ByteFillCanary -j 2 $VIDEO_FLAG > /tmp/canary.log 2>&1
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

echo "[canary] parsing $CSV"
mapfile -t rows < <(awk -F, 'NR>1 && $1 ~ /_ByteFillCanary$/ { print $1","$2","$3 }' "$CSV")

if [ "${#rows[@]}" -eq 0 ]; then
    echo "FAIL: no ByteFillCanary rows in CSV (parsing problem or job didn't run)"
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
    echo "PASS: harness correctly detected the canary's divergence on all bk2s"
    exit 0
else
    echo
    echo "FAIL: harness did NOT detect the canary — validator is broken"
    exit 1
fi
