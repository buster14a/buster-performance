#!/bin/bash
# #426: user/kernel instructions and cycles of the whole compile, main's tree against part 1's, without -g, interleaved.
cd ~/buster-fast-bench/dwarf395/rows3 || exit 1
for i in 1 2 3; do
    for t in main part1; do
        echo "== $t round $i"
        perf stat -x, -e instructions:u,cycles:u,instructions:k,cycles:k,branch-misses:u -r 21 taskset -c 2 $t/build/compiler -o tmp/program-$t tmp/program.c 2>&1 >/dev/null | cut -d, -f1,3,4
    done
done
