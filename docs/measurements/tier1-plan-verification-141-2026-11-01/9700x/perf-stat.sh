#!/usr/bin/env bash
# perf-stat.sh BASE HEAD: user-space instructions and cycles of --tier1 -c of the frozen sqlite3.c, 11 runs per tree in
# turn, 3 rounds, each one hold of the shared lock, pinned to CPU 2.
. ~/buster-fast-bench/claude-141-remaining/common.sh
out=$PWD/perf-stat-$2
mkdir -p $out
for r in 1 2 3; do
    for t in $1 $2; do
        "$lock" bash -c "taskset -c 2 perf stat -x, -e instructions:u,cycles:u -r 11 -o $out/$t-$r.csv $PWD/$t/build/compiler --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/perf-$t.o $Q/sqlite3.c"
    done
done
for f in $out/*.csv; do echo "$(basename $f .csv) $(grep -E 'instructions|cycles' $f | cut -d, -f1,3 | tr '\n' ' ')"; done > $out/summary.txt
echo done > $out/done
