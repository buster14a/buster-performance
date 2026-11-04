#!/usr/bin/env bash
# variant.sh: the head with the intrinsic's rule deferred to the verifier's scalar path (var-defer: ir.c's
# ir_check_batch without the rule's vector checks, its source variant/ir_defer.c), built as the others; then perf stat
# of --tier1 -c of the frozen sqlite3.c by main, the head and the variant, 11 runs a hold, 3 rounds in a rotating order,
# pinned to CPU 2, whether the three sqlite3.o are identical, and which builds have ir_constant_fits out of line
# (variant/).
. ~/buster-fast-bench/claude-141-intrinsics/common.sh
mkdir -p variant
./build.sh var-defer
trees=(main-48ac6d71 head-b37f0d25 var-defer)
for r in 1 2 3; do
    for k in "${!trees[@]}"; do
        t=${trees[$(( (k + r) % ${#trees[@]} ))]}
        "$lock" bash -c "taskset -c 2 perf stat -x, -e instructions:u,cycles:u -r 11 -o $PWD/variant/stat-$t-$r.csv $PWD/$t/build/compiler --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/variant-$t.o $Q/sqlite3.c"
    done
done
{ cmp $RUNDIR/variant-main-48ac6d71.o $RUNDIR/variant-head-b37f0d25.o && cmp $RUNDIR/variant-main-48ac6d71.o $RUNDIR/variant-var-defer.o && echo "sqlite3.o: the three are identical"; } > variant/cmp.txt 2>&1
for t in "${trees[@]}"; do echo "$t: $(nm $t/build/compiler | grep -c ' ir_constant_fits$') out-of-line ir_constant_fits"; done > variant/inlining.txt
touch variant/done
