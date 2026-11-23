#!/usr/bin/env bash
# kernels.sh: #2743's array-loop kernels (its record's harness.c, kernels.c and kernels.h) at -march=znver5 by base's and
# head's --tier1 -O2, each linked with clang -O2's harness, in one lock hold, CPU 2: each kernel calibrated (REPS 0), the
# two builds alternating kernel by kernel, A first on even kernels; then perf's user cycles at the calibrated repetitions.
# Digests must match.
set -u
source "$(dirname "$0")/common.sh"
cd $W || exit 1
O=out/kernels
mkdir -p $O
$CLANG -O2 -Wall -Wextra -c src/harness.c -o $O/harness.o || exit 1
for name in base head; do
    $W/bin/$name --tier1 -O2 -march=znver5 -c src/kernels.c -o $O/k-$name.o 2> $O/k-$name.log || exit 1
    $CLANG $O/harness.o $O/k-$name.o -o $O/h-$name -lm || exit 1
    python3 loops.py $O/h-$name > $O/h-$name.loops
done
$LOCK bash -c "$(declare -f state); state kernels; i=0
for k in \$($O/h-base list); do
    if [ \$((i % 2)) = 0 ]; then order='base head'; else order='head base'; fi
    for name in \$order; do
        H=$O/h-\$name
        line=\$(taskset -c 2 \$H \$k 0 2>&1)
        reps=\$(echo \"\$line\" | cut -d' ' -f3)
        taskset -c 2 perf stat -x, -e cycles:u,instructions:u -o $O/perf.txt -- \$H \$k \$reps > /dev/null 2>&1
        echo \"\$name \$line | cycles \$(grep cycles $O/perf.txt | cut -d, -f1) instructions \$(grep instructions $O/perf.txt | cut -d, -f1)\"
    done
    i=\$((i + 1))
done
state kernels-end" > $O/results.txt 2>&1
