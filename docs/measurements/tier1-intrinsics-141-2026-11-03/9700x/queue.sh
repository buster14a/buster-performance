#!/usr/bin/env bash
# queue.sh: buster's head b37f0d25 (#141's x86 builtins as IR intrinsics, on main 48ac6d71) against that main: both
# builds; the touched tests by the head (tests/); kernel.c's programs (kernel.sh, kernel/); perf stat of --tier1 -c of
# the frozen sqlite3.c and whether the two sqlite3.o are identical (bisect.sh, bisect/); benchmark-ir (verifier.sh,
# verifier/); and the compiler's own main.c by --tier1 -march=native, functions by Tier 1 (selfhost/).
. ~/buster-fast-bench/claude-141-intrinsics/common.sh
./build.sh $TREES
./tests.sh head-b37f0d25
./kernel.sh
./bisect.sh $TREES
./verifier.sh
mkdir -p selfhost
for t in $TREES; do
    "$lock" bash -c "cd $t && taskset -c 2 build/compiler --tier1 --tier1-report --tier1-refusals -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -c -o $RUNDIR/self-$t.o src/buster/compiler/main.c > ../selfhost/$t.txt 2>&1; echo \"exit \$?\" >> ../selfhost/$t.txt"
done
touch queue.done
