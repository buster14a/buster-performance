#!/usr/bin/env bash
# variant-fix2.sh: var-fix with variant-inline/fix2.patch too (ir_simd_value_valid always inlined), var-fix2, built as
# the others; then perf stat of --tier1 -c of the frozen sqlite3.c by main, var-fix and var-fix2, 11 runs a hold, 3
# rounds in a rotating order, pinned to CPU 2, whether the three sqlite3.o are identical, and which builds have
# ir_constant_fits and ir_simd_value_valid out of line (variant-fix2/).
. ~/buster-fast-bench/claude-141-intrinsics/common.sh
mkdir -p variant-fix2
rm -rf var-fix2 && mkdir var-fix2 && (cd var-fix && tar cf - --exclude=./build .) | (cd var-fix2 && tar xf -)
( cd var-fix2 && patch -p1 < ../variant-inline/fix2.patch ) > variant-fix2/patch.txt 2>&1
./build.sh var-fix2
trees=(main-48ac6d71 var-fix var-fix2)
for r in 1 2 3; do
    for k in "${!trees[@]}"; do
        t=${trees[$(( (k + r) % ${#trees[@]} ))]}
        "$lock" bash -c "taskset -c 2 perf stat -x, -e instructions:u,cycles:u -r 11 -o $PWD/variant-fix2/stat-$t-$r.csv $PWD/$t/build/compiler --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/variant-fix2-$t.o $Q/sqlite3.c"
    done
done
{ cmp $RUNDIR/variant-fix2-main-48ac6d71.o $RUNDIR/variant-fix2-var-fix.o && cmp $RUNDIR/variant-fix2-main-48ac6d71.o $RUNDIR/variant-fix2-var-fix2.o && echo "sqlite3.o: the three are identical"; } > variant-fix2/cmp.txt 2>&1
for t in "${trees[@]}"; do for f in ir_constant_fits ir_simd_value_valid; do echo "$t: $(nm $t/build/compiler | grep -c " $f\$") out-of-line $f"; done; done > variant-fix2/inlining.txt
touch variant-fix2/done
