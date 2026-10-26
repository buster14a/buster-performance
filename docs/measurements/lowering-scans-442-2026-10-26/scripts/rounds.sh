#!/bin/bash
# #442: interleaved rounds of benchmark-emit-ab over c-testsuite's single-exec programs, each tree's run pinned to CPU
# 2, the trees' order rotating by round. Usage: rounds.sh OUTDIR ROUNDS TREE...
# TREES is build-trees.sh's output directory, CTS a c-testsuite checkout (commit 5c72756), PASSES the passes per run
# (101 here; at least 21), FILES the inputs instead of c-testsuite's (a list, split on spaces). On the 9700X, set LOCK to ~/buster-fast-bench/exclusive.sh (with EXCLUSIVE_OWNER and the
# rest), which takes the shared lock for each run alone.
out=$1; rounds=$2; shift 2; trees=("$@")
mkdir -p "$out"
for ((r = 1; r <= rounds; r++)); do
    n=${#trees[@]}
    for ((k = 0; k < n; k++)); do
        t=${trees[$(((k + r - 1) % n))]}
        $LOCK taskset -c 2 "$TREES/$t/build/compiler" benchmark-emit-ab --passes ${PASSES:-21} ${FILES:-"$CTS"/tests/single-exec/*.c} > "$out/round-$r-$t.txt" 2> "$out/round-$r-$t.err"
        echo "round $r $t exit=$? $(grep totals "$out/round-$r-$t.txt")" >> "$out/log.txt"
    done
done
