#!/bin/bash
# #2959: the insertion path's variants in one executable, built from main 6eaf73cfd + ../counts.patch + ../align.patch
# with the toolchain's clang -O3 -march=native (variants.c; unit_body.h includes the module): the insertion sort in a
# 64-byte-aligned function of its own (insertion), the same comparing 128-bit keys (int128), and diagnostic_sort with
# its stack arrays aligned (diagnostic_sort); best of 31 passes of 64 sorts. Three processes under the lock on CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: diagnostics' small path (#2959)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2959
L=~/buster-fast-bench/exclusive.sh
for run in 1 2 3; do
    $L timeout -k 5 300 taskset -c 2 ./variants > run-$run.log 2>&1
    echo "run $run: $?" >> status.txt
done
date -u +%FT%TZ > .done
