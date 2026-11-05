#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/1219-codex"
export S=$PWD
export EXCLUSIVE_OWNER=codex-1219 EXCLUSIVE_TITLE='Issue 1219 review regression coverage' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1419
(cd review && "$HOME/buster-fast-bench/exclusive.sh" env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --jobs 8) > review-build.log 2>&1
set +e
(cd review && "$HOME/buster-fast-bench/exclusive.sh" ./build/compiler test-tier1-select) > review-select.log 2>&1
status=$?
printf '%s\n' "$status" > review-recheck.done
set -e
test "$status" = 0
"$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 bash scripts/progs.sh "$PWD/review/build/compiler" "$PWD/results/review"
for program in st-t1 lua-t1; do
    cmp "results/affine/$program" "results/review/$program"
    printf '%s byte-identical to measured candidate\n' "$program" >> review-programs-identical.txt
done
sha256sum review/build/compiler review/src/buster/compiler/tier1_select.c review/src/buster/compiler/tier1_select_test.c results/review/{st-t1,lua-t1} > review-binaries.sha256
touch review-validation.done
