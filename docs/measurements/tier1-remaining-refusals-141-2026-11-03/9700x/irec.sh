#!/usr/bin/env bash
# irec.sh TREE...: perf record of instructions:u (every 200000th) over 5 --tier1 -c compiles of the frozen sqlite3.c per
# tree, one hold of the shared lock each, pinned to CPU 2; per-symbol reports in irec/.
. ~/buster-fast-bench/claude-141-wide/common.sh
mkdir -p irec
for t in "$@"; do
    "$lock" bash -c "cd $RUNDIR && taskset -c 2 perf record -e instructions:u -c 200000 -o $RUNDIR/irec-$t.data -- bash -c 'for i in 1 2 3 4 5; do $PWD/$t/build/compiler --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/irec-$t.o $Q/sqlite3.c; done' > /dev/null 2>&1; perf report -i $RUNDIR/irec-$t.data --stdio --no-children --sort symbol -F overhead,sample,symbol > $PWD/irec/report-$t.txt 2>&1"
done
touch irec/done
