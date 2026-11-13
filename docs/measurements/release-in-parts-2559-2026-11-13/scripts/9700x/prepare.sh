#!/bin/bash
# The benchmarks' inputs, once, inside the lock (lock.sh): the predefines the 9700X job writes, c-testsuite at its
# pinned commit and the dominators' exported CFGs, into inputs/; then the benchmark list (list.sh).
set -eu
d=$HOME/buster-fast-bench/2559-release-claude
. "$d/scripts/env.sh"
mkdir -p "$d/inputs"
cd "$d/base"
clang -dM -E -march="$BUSTER_HOST_ARCH" -fwrapv -funsigned-char -x c /dev/null > "$d/inputs/predefines.h"
if [ ! -d "$d/inputs/c-testsuite/tests" ]; then
    rm -rf "$d/inputs/c-testsuite"
    git init -q --template= "$d/inputs/c-testsuite"
    git -C "$d/inputs/c-testsuite" fetch -q --depth 1 https://github.com/c-testsuite/c-testsuite 5c7275656d751de0e68b2d340a95b5681858ed07
    git -C "$d/inputs/c-testsuite" checkout -q FETCH_HEAD
fi
taskset -c 2 "$d/placements/base/compiler-0" test-ir-source --dominators-cfg "$d/inputs/dominators-fixture.cfg" tests/ir-source/dominators.c > "$d/logs/prepare-dominators.log" 2>&1
"$d/scripts/list.sh" > "$d/inputs/benchmarks.txt"
wc -l "$d/inputs/benchmarks.txt"
