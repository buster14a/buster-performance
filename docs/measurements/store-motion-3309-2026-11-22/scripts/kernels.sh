#!/bin/bash
# The issue's kernels on the 9700X: each kernel's seven builds under one hold of the lock, then ROUNDS rounds of every
# build's run under one more (a few seconds), pinned to CPU 2, the builds' order rotating by round; perf stat's user
# task clock, cycles and instructions of each run.
W=$HOME/buster-fast-bench/3309-fable
C=${C:-$HOME/buster-fast-bench/3309-claude/tree/build/compiler}
export EXCLUSIVE_OWNER=claude-3309-fable EXCLUSIVE_TITLE='buster #3309: loop store motion (kernels)' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3309
L=$HOME/buster-fast-bench/exclusive.sh
ROUNDS=${ROUNDS:-7}
cd $W/kernels || exit 1
: > results.txt
sha256sum $C >> results.txt
for k in k1 k2 k3 k4; do
    $L bash -c "$C -o $k-t0 $k.c && $C --tier1 --tier1-passes=-storemotion -o $k-t1 $k.c && $C --tier1 --tier1-passes=+storemotion -o $k-sm $k.c && $C --tier1 --tier1-passes=+all -o $k-all $k.c && clang -O0 -o $k-c0 $k.c && clang -O2 -o $k-c2 $k.c && clang -O2 -fno-unroll-loops -fno-vectorize -fno-slp-vectorize -o $k-c2n $k.c" > build-$k.txt 2>&1 || { echo "$k build failed" >> results.txt; continue; }
    script='for b in t0 t1 sm all c0 c2 c2n; do ./'$k'-$b > out-'$k'-$b.txt; cmp -s out-'$k'-c0.txt out-'$k'-$b.txt || echo "'$k' $b OUTPUT DIFFERS"; done; builds="t0 t1 sm all c0 c2 c2n"; for r in $(seq '$ROUNDS'); do for b in $builds; do taskset -c 2 perf stat -x, -e task-clock:u,cycles:u,instructions:u -o stat.txt ./'$k'-$b > /dev/null; echo "'$k' $b $r $(cut -d, -f1 stat.txt | grep -E "^[0-9]" | tr "\n" " ")"; done; builds="${builds#* } ${builds%% *}"; done'
    $L bash -c "$script" >> results.txt 2> lock-$k.txt
done
echo done >> results.txt
