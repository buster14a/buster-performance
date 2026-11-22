#!/bin/bash
# Instruction and cycle profiles of benchmark-preprocessor on main.c (vectorized kernels, -E -P's printing), by
# function, for each tree given: perf record under the 9700X's lock alone, pinned to CPU 2 (#2925's default path).
set -u
D=~/buster-fast-bench/1380-claude-2925
export EXCLUSIVE_OWNER=claude-2925 EXCLUSIVE_TITLE='PR sweep: #2925 -E modes' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2925
mkdir -p $D/perf
cd $D/head
for t in "$@"; do
    $D/lockps.sh timeout -k 5 120 taskset -c 2 perf record -q -o $D/perf/$t.data -e instructions:u -c 200003 -e cycles:u -c 200003 \
        $D/$t/build/compiler benchmark-preprocessor --only vectorized -march=native -Isrc -fwrapv -funsigned-char src/buster/compiler/main.c > $D/perf/$t.run.log 2>&1
    echo "$t perf exit $?"
    for e in instructions:u cycles:u; do
        perf report -i $D/perf/$t.data --stdio -n --no-children --sort sym --event $e 2>/dev/null | grep -v '^#' | grep -v '^$' | head -60 > $D/perf/$t.$e.txt
    done
done
