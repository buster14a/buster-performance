#!/usr/bin/env bash
# attribute-fix.sh: where var-fix's --tier1 -c of the frozen sqlite3.c spends user-mode instructions against main's, by
# symbol: perf record of instructions:u at a fixed period of 20,000, one compile a hold, each tree three times in a
# rotating order, pinned to CPU 2, reported by symbol with sample counts (attribute-fix/).
. ~/buster-fast-bench/claude-141-intrinsics/common.sh
mkdir -p attribute-fix
trees=(main-48ac6d71 var-fix)
for r in 1 2 3; do
    for k in "${!trees[@]}"; do
        t=${trees[$(( (k + r) % ${#trees[@]} ))]}
        "$lock" bash -c "cd $RUNDIR && taskset -c 2 perf record -e instructions:u -c 20000 -o $RUNDIR/attribute-fix-$t-$r.data -- $PWD/$t/build/compiler --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/attribute-fix-$t.o $Q/sqlite3.c > /dev/null 2>&1; perf report -i $RUNDIR/attribute-fix-$t-$r.data --stdio --no-children --sort symbol -F overhead,sample,symbol > $PWD/attribute-fix/report-$t-$r.txt 2>&1"
    done
done
touch attribute-fix/done
