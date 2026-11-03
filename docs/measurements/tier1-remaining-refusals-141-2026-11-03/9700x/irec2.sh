#!/usr/bin/env bash
# irec2.sh TREE...: perf record of instructions:u, one sample per 2,000,003 (below perf's throttling rate), over 20
# --tier1 -c compiles of the frozen sqlite3.c per tree, one hold of the shared lock each, CPU 2; per-symbol sample counts
# and the throttle events' count in irec2/.
. ~/buster-fast-bench/claude-141-wide/common.sh
mkdir -p irec2
for t in "$@"; do
    "$lock" bash -c "cd $RUNDIR && taskset -c 2 perf record -e instructions:u -c 2000003 -o $RUNDIR/irec2-$t.data -- bash -c 'for i in \$(seq 20); do $PWD/$t/build/compiler --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/irec2-$t.o $Q/sqlite3.c; done' > /dev/null 2>&1; perf report -i $RUNDIR/irec2-$t.data --stdio --no-children --comm compiler --sort symbol -F overhead,sample,symbol > $PWD/irec2/report-$t.txt 2>&1; perf report -i $RUNDIR/irec2-$t.data -D 2>/dev/null | grep -c THROTTLE > $PWD/irec2/throttle-$t.txt"
done
touch irec2/done
