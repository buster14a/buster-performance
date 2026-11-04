#!/usr/bin/env bash
# attribute-slow.sh: attribute-fix.sh's comparison below the kernel's sample-rate limit (63,300 samples/s here; a compile
# retires about 13 G instructions/s): perf record of instructions:u at a period of 250,000, ten compiles a hold, each
# tree three times in a rotating order, pinned to CPU 2, with the throttle events perf counts, reported by symbol with
# sample counts (attribute-slow/).
. ~/buster-fast-bench/claude-141-intrinsics/common.sh
mkdir -p attribute-slow
trees=(main-48ac6d71 var-fix)
for r in 1 2 3; do
    for k in "${!trees[@]}"; do
        t=${trees[$(( (k + r) % ${#trees[@]} ))]}
        "$lock" bash -c "cd $RUNDIR && taskset -c 2 perf record -e instructions:u -c 250000 -o $RUNDIR/attribute-slow-$t-$r.data -- bash -c 'for i in 1 2 3 4 5 6 7 8 9 10; do $PWD/$t/build/compiler --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/attribute-slow-$t.o $Q/sqlite3.c; done' > /dev/null 2>&1; perf report -i $RUNDIR/attribute-slow-$t-$r.data --stdio --no-children --sort symbol -F overhead,sample,symbol > $PWD/attribute-slow/report-$t-$r.txt 2>&1; perf report -i $RUNDIR/attribute-slow-$t-$r.data --stats 2>&1 | grep -i -E 'throttle|lost|sample' > $PWD/attribute-slow/stats-$t-$r.txt"
    done
done
touch attribute-slow/done
