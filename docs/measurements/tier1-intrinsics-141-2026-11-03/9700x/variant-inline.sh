#!/usr/bin/env bash
# variant-inline.sh: the head with ir_constant_fits always inlined (var-inline, its ir.c variant/ir_inline.c), built as
# the others; then perf stat of --tier1 -c of the frozen sqlite3.c by main, the head and the variant, 11 runs a hold, 3
# rounds in a rotating order, pinned to CPU 2, whether the three sqlite3.o are identical, and which builds have
# ir_constant_fits and ir_simd_value_valid out of line (variant-inline/).
. ~/buster-fast-bench/claude-141-intrinsics/common.sh
mkdir -p variant-inline
./build.sh var-inline
trees=(main-48ac6d71 head-b37f0d25 var-inline)
for r in 1 2 3; do
    for k in "${!trees[@]}"; do
        t=${trees[$(( (k + r) % ${#trees[@]} ))]}
        "$lock" bash -c "taskset -c 2 perf stat -x, -e instructions:u,cycles:u -r 11 -o $PWD/variant-inline/stat-$t-$r.csv $PWD/$t/build/compiler --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/variant-inline-$t.o $Q/sqlite3.c"
    done
done
{ cmp $RUNDIR/variant-inline-main-48ac6d71.o $RUNDIR/variant-inline-head-b37f0d25.o && cmp $RUNDIR/variant-inline-main-48ac6d71.o $RUNDIR/variant-inline-var-inline.o && echo "sqlite3.o: the three are identical"; } > variant-inline/cmp.txt 2>&1
for t in "${trees[@]} var-defer"; do for f in ir_constant_fits ir_simd_value_valid; do echo "$t: $(nm $t/build/compiler | grep -c " $f\$") out-of-line $f"; done; done > variant-inline/inlining.txt
touch variant-inline/done
