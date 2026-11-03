#!/usr/bin/env bash
# bisect.sh TREE...: perf stat of each tree's --tier1 -c of the frozen sqlite3.c, 11 runs a hold, 3 rounds in a rotating
# order; then perf record of the first and the last tree, 5 compiles each at 20 kHz. Outputs in bisect/.
. ~/buster-fast-bench/claude-141-wide/common.sh
trees=("$@")
out=${BISECT_OUT:-bisect}; mkdir -p $out
for r in 1 2 3; do
    for k in "${!trees[@]}"; do
        t=${trees[$(( (k + r) % ${#trees[@]} ))]}
        "$lock" bash -c "taskset -c 2 perf stat -x, -e instructions:u,cycles:u -r 11 -o $PWD/$out/stat-$t-$r.csv $PWD/$t/build/compiler --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/bisect-$t.o $Q/sqlite3.c"
    done
done
for t in "${trees[0]}" "${trees[$(( ${#trees[@]} - 1 ))]}"; do
    "$lock" bash -c "cd $RUNDIR && taskset -c 2 perf record -e cycles:u -F 20000 -o $RUNDIR/bisect-$t.data -- bash -c 'for i in 1 2 3 4 5; do $PWD/$t/build/compiler --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/bisect-record-$t.o $Q/sqlite3.c; done' > /dev/null 2>&1; perf report -i $RUNDIR/bisect-$t.data --stdio --no-children --sort symbol > $PWD/$out/report-$t.txt 2>&1"
done
touch $out/done
