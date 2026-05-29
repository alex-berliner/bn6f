#!/usr/bin/env bash
# Full test suite for the BN6F decomp project.
#
# Runs the harness self-checks first (don't trust a validator that
# can't catch a known-bad patch), then would run the per-patch sweep
# if requested.
#
# This is NOT run on every developer invocation. Run it:
#   - before a release / before claiming "harness verified"
#   - after any change to tools/bn6f-validate/
#   - after upgrading vendored libmgba
#
# Exit 0 if all tests pass, non-zero on first failure.

set -u
cd "$(git rev-parse --show-toplevel)"

pass=0
fail=0
failed_tests=()

run_test() {
    local name=$1
    shift
    echo
    echo "============================================================"
    echo "[run_all] $name"
    echo "============================================================"
    if "$@"; then
        echo "[run_all] $name: PASS"
        pass=$((pass + 1))
    else
        echo "[run_all] $name: FAIL"
        fail=$((fail + 1))
        failed_tests+=("$name")
    fi
}

# 1. Harness divergence canary — must detect a deliberately-broken patch.
run_test "canary divergence" bash tests/harness/canary.sh

# Future additions go here:
#   - Determinism test: hash the same ROM twice, assert identical
#   - Savestate-load test: tutorial bk2 loads and runs >100 frames
#   - Per-patch sweep (slow; gated behind RUN_FULL_SWEEP=1)
# if [ "${RUN_FULL_SWEEP:-0}" = "1" ]; then
#     run_test "full per-patch sweep" \
#         tools/bn6f-validate/target/release/bn6f-validate run -j 8
# fi

echo
echo "============================================================"
echo "[run_all] tests passed: $pass"
echo "[run_all] tests failed: $fail"
if [ "$fail" -gt 0 ]; then
    echo "[run_all] failed: ${failed_tests[*]}"
    exit 1
fi
exit 0
