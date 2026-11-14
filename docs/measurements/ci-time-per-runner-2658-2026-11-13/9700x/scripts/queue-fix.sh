#!/bin/bash
# The branch's Release build, its fixture ownership check, then its Debug build (whose -Werror the CI's builds take).
set -u
cd ~/buster-fast-bench/2658-claude
hold()
{
    local title=$1
    shift
    EXCLUSIVE_OWNER=claude-2658 EXCLUSIVE_TITLE="CI time per runner: $title" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2658 \
        ~/buster-fast-bench/exclusive.sh timeout -k 10 590 "$@"
}
hold "branch Release build" scripts/build-tree.sh glue runs/build-branch4-x86-64 BUSTER_HOST_ARCH=x86-64 BUSTER_DEBUG_INFO=0 2> runs-build-branch4.stderr | tail -1
hold "fixture ownership check" bash -c "cd glue && cc -std=c17 -O2 -Wall -Wextra -Werror -o build/build-regression tools/ci/build_regression.c && build/build-regression --ownership-only \$PWD/build/cmake/x86-64-g0/Release/compiler" > runs/ownership-2.txt 2>&1
grep -i "fingerprint\|ok: Release\|FAILED" runs/ownership-2.txt | cut -c1-260
export BUILD_ARGS="--config Debug"; hold "branch Debug build" scripts/build-tree.sh glue runs/build-branch-debug BUSTER_HOST_ARCH=x86-64 2> runs-build-branch-debug.stderr | tail -2
grep -m3 "error:" runs/build-branch-debug/build.log
