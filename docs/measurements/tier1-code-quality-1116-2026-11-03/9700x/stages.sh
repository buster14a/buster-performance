#!/usr/bin/env bash
# stages.sh BASE HEAD: on the 9700X, one hold, CPU 2: 11 alternating --time-stages runs of each tree's --tier1 -c of the
# frozen sqlite3.c, then perf stat (instructions, cycles, branch misses) of 5 runs each; outputs in stages-HEAD/.
. ~/buster-fast-bench/1116-claude/common.sh
base=$1
head=$2
out=$PWD/stages-$head
mkdir -p $out
"$lock" bash -c "for r in 1 2 3 4 5 6 7 8 9 10 11; do for t in $base $head; do taskset -c 2 $PWD/\$t/build/compiler --time-stages --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/stages-\$t.o $Q/sqlite3.c 2> $out/stages-\$t-\$r.txt; done; done; for t in $base $head; do taskset -c 2 perf stat -x, -e instructions:u,cycles:u,branch-misses:u,L1-icache-load-misses:u -r 5 -o $out/stat-\$t.csv $PWD/\$t/build/compiler --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/stages-\$t.o $Q/sqlite3.c; done"
echo "exit $?" > $out/done
