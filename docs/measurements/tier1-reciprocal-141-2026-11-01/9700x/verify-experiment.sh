#!/usr/bin/env bash
# verify-experiment.sh: how much of selection's time is the IR verification tier1_select_plan runs first. The tree
# exp-verify-1ea8b02 is 1ea8b02 with verify-experiment.diff (not committed anywhere): benchmark-tier1-select-source
# with two more variants, ir_verify and ir_verify_scalar alone on the same functions and dominance. Its build, then
# every variant interleaved and each alone, each one hold of the shared lock, pinned to CPU 2.
. ~/buster-fast-bench/claude-141-reciprocal/common.sh
t=exp-verify-1ea8b02
./build.sh $t
grep -q "^exit 0" logs-build/$t.log || exit 1
out=$PWD/verify-experiment
mkdir -p $out
"$lock" bash -c "taskset -c 2 $PWD/$t/build/compiler benchmark-tier1-select-source $FLAGS -I$Q $Q/sqlite3.c > $out/all.txt 2>&1; echo \"exit \$?\" >> $out/all.txt"
for v in select select-scalar verify verify-scalar; do
    "$lock" bash -c "taskset -c 2 $PWD/$t/build/compiler benchmark-tier1-select-source --only $v $FLAGS -I$Q $Q/sqlite3.c > $out/$v.txt 2>&1; echo \"exit \$?\" >> $out/$v.txt"
done
echo done > $out/done
