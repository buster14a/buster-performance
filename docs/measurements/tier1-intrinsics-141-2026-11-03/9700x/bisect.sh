#!/usr/bin/env bash
# bisect.sh TREE...: perf stat of each tree's --tier1 -c of the frozen sqlite3.c, 11 runs a hold, 3 rounds in a rotating
# order, pinned to CPU 2; whether the trees' sqlite3.o are byte-identical (cmp.txt). Outputs in bisect/.
. ~/buster-fast-bench/claude-141-intrinsics/common.sh
trees=("$@")
mkdir -p bisect
for r in 1 2 3; do
    for k in "${!trees[@]}"; do
        t=${trees[$(( (k + r) % ${#trees[@]} ))]}
        "$lock" bash -c "taskset -c 2 perf stat -x, -e instructions:u,cycles:u -r 11 -o $PWD/bisect/stat-$t-$r.csv $PWD/$t/build/compiler --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/bisect-$t.o $Q/sqlite3.c"
    done
done
{ cmp $RUNDIR/bisect-${trees[0]}.o $RUNDIR/bisect-${trees[1]}.o && echo "sqlite3.o: ${trees[0]}'s and ${trees[1]}'s are identical"; } > bisect/cmp.txt 2>&1
touch bisect/done
