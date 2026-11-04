#!/usr/bin/env bash
# attribute.sh: where --tier1 -c of the frozen sqlite3.c spends its user-mode instructions, by symbol, in each tree:
# perf record of instructions:u at a fixed period of 100,000 (5 compiles a tree, pinned to CPU 2), reported by symbol
# with sample counts (attribute/).
. ~/buster-fast-bench/claude-141-intrinsics/common.sh
mkdir -p attribute
for t in $TREES; do
    "$lock" bash -c "cd $RUNDIR && taskset -c 2 perf record -e instructions:u -c 100000 -o $RUNDIR/attribute-$t.data -- bash -c 'for i in 1 2 3 4 5; do $PWD/$t/build/compiler --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/attribute-$t.o $Q/sqlite3.c; done' > /dev/null 2>&1; perf report -i $RUNDIR/attribute-$t.data --stdio --no-children --sort symbol -F overhead,sample,symbol > $PWD/attribute/report-$t.txt 2>&1"
done
touch attribute/done
