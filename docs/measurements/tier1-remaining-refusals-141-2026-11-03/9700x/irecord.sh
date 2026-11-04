#!/usr/bin/env bash
# irecord.sh TREE...: perf record of instructions:u (one sample per 200,000) over one --tier1 -c of the frozen sqlite3.c by
# each tree, one hold each, CPU 2; each tree's report by symbol in irecord/.
. ~/buster-fast-bench/claude-141-wide/common.sh
mkdir -p irecord
for t in "$@"; do
    "$lock" bash -c "cd $RUNDIR && taskset -c 2 perf record -e instructions:u -c 200000 -o $RUNDIR/irecord-$t.data $PWD/$t/build/compiler --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/irecord-$t.o $Q/sqlite3.c > /dev/null 2>&1; perf report -i $RUNDIR/irecord-$t.data --stdio --no-children --sort symbol -F overhead,period,symbol > $PWD/irecord/report-$t.txt 2>&1"
done
touch irecord/done
