#!/usr/bin/env bash
# cost-profile.sh BASE HEAD: where head's --tier1 -c of the frozen sqlite3.c spends the cycles base's doesn't: for each
# tree, perf stat of 5 runs (cycles, instructions, branch misses, and Zen 5's dispatch slots lost to the front end and to
# the back end), then perf record of cycles:u and of instructions:u (a sample per 20,000) of 3 runs, every run --lanes 1
# on CPU 2, each tree's runs one hold of the shared lock; each profile's samples by symbol.
. ~/buster-fast-bench/claude-141-reciprocal/common.sh
out=$PWD/cost-profile-$2
mkdir -p $out
for t in "$1" "$2"; do
    "$lock" bash -c "cd $RUNDIR && taskset -c 2 perf stat -x, -r 5 -e cycles:u,instructions:u,branch-misses:u,r1000001a0:u,r100001ea0:u -o $out/stat-$t.txt -- $PWD/$t/build/compiler --tier1 --lanes 1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/cost-$t.o $Q/sqlite3.c > /dev/null 2>&1; for e in cycles instructions; do for r in 1 2 3; do taskset -c 2 perf record -q -e \$e:u -c 20000 -o $out/perf-\$e-$t-\$r.data -- $PWD/$t/build/compiler --tier1 --lanes 1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/cost-$t.o $Q/sqlite3.c > /dev/null 2>&1; done; done"
    for e in cycles instructions; do
        for r in 1 2 3; do
            perf report -i $out/perf-$e-$t-$r.data --stdio --no-children --sort symbol -F sample,symbol 2>/dev/null | grep -v "^#" | grep -v "^$" > $out/symbols-$e-$t-$r.txt
        done
    done
done
echo done > $out/done
