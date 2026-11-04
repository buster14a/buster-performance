#!/usr/bin/env bash
# queue.sh: buster#1245's head f3de5433 (its merge with main 94d253b4) against that main: both builds; perf stat of
# --tier1 -c of the frozen sqlite3.c (bisect.sh, bisect/) and whether the two sqlite3.o are byte-identical (cmp.txt);
# ab, 5 rounds of 21 runs (ab/); and the compiler's own main.c by --tier1 -march=native, functions by Tier 1 (selfhost/).
. ~/buster-fast-bench/claude-141-1245/common.sh
./build.sh main-94d253b4 head-f3de5433
BISECT_OUT=bisect ./bisect.sh main-94d253b4 head-f3de5433
{ cmp $RUNDIR/bisect-main-94d253b4.o $RUNDIR/bisect-head-f3de5433.o && echo "sqlite3.o: 94d253b4's and f3de5433's are identical"; } > bisect/cmp.txt 2>&1
mkdir -p ab
head-f3de5433/build/compiler ab --rounds 5 --cpu 2 --lock $lock main-94d253b4 head-f3de5433 -- time-runs --runs 21 --list --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/ab.o $Q/sqlite3.c > ab/compile-tier1-ab.log 2>&1
echo "exit $?" >> ab/compile-tier1-ab.log
mkdir -p selfhost
for t in main-94d253b4 head-f3de5433; do
    "$lock" bash -c "cd $t && taskset -c 2 build/compiler --tier1 --tier1-report --tier1-refusals -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -c -o $RUNDIR/self-$t.o src/buster/compiler/main.c > ../selfhost/$t.txt 2>&1; echo \"exit \$?\" >> ../selfhost/$t.txt"
done
touch queue.done
