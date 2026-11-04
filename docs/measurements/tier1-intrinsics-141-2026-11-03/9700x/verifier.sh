#!/usr/bin/env bash
# verifier.sh: benchmark-ir of each tree (the IR verifier's vector path checks the intrinsic's rule among the others),
# --only vector and --only scalar, 3 rounds in a rotating order, pinned to CPU 2 (verifier/).
. ~/buster-fast-bench/claude-141-intrinsics/common.sh
trees=($TREES)
mkdir -p verifier
for r in 1 2 3; do
    for k in "${!trees[@]}"; do
        t=${trees[$(( (k + r) % ${#trees[@]} ))]}
        for only in vector scalar; do
            "$lock" bash -c "taskset -c 2 $t/build/compiler benchmark-ir --only $only > verifier/$t-$only-$r.txt 2>&1; echo \"exit \$?\" >> verifier/$t-$only-$r.txt"
        done
    done
done
touch verifier/done
