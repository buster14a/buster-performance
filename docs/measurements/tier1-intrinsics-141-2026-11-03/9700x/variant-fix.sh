#!/usr/bin/env bash
# variant-fix.sh: the head with fix.patch (variant-inline/fix.patch: ir_constant_fits always inlined, and selection's two
# intrinsic candidates' tests one), var-fix, built as the others; then perf stat of --tier1 -c of the frozen sqlite3.c
# by main, the head and the variant, 11 runs a hold, 3 rounds in a rotating order, pinned to CPU 2, whether the three sqlite3.o are identical, and which builds have
# ir_constant_fits and ir_simd_value_valid out of line (variant-fix/).
. ~/buster-fast-bench/claude-141-intrinsics/common.sh
mkdir -p variant-fix
( cd var-fix && patch -p1 < ../variant-inline/fix.patch ) > variant-fix/patch.txt 2>&1
./build.sh var-fix
trees=(main-48ac6d71 head-b37f0d25 var-fix)
for r in 1 2 3; do
    for k in "${!trees[@]}"; do
        t=${trees[$(( (k + r) % ${#trees[@]} ))]}
        "$lock" bash -c "taskset -c 2 perf stat -x, -e instructions:u,cycles:u -r 11 -o $PWD/variant-fix/stat-$t-$r.csv $PWD/$t/build/compiler --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/variant-fix-$t.o $Q/sqlite3.c"
    done
done
{ cmp $RUNDIR/variant-fix-main-48ac6d71.o $RUNDIR/variant-fix-head-b37f0d25.o && cmp $RUNDIR/variant-fix-main-48ac6d71.o $RUNDIR/variant-fix-var-fix.o && echo "sqlite3.o: the three are identical"; } > variant-fix/cmp.txt 2>&1
for t in "${trees[@]}"; do for f in ir_constant_fits ir_simd_value_valid; do echo "$t: $(nm $t/build/compiler | grep -c " $f\$") out-of-line $f"; done; done > variant-fix/inlining.txt
touch variant-fix/done
