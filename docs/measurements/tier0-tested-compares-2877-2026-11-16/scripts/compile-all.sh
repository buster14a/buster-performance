#!/bin/bash
# compile-all.sh LABEL CORPUS [PASSES]: the corpus's -c compiles by results/LABEL/compiler, a process a file, in the
# list's order, PASSES times (default 1), the objects written to /dev/shm/claude-2877-o-LABEL. Prints how many compiles
# there were and how many failed. The caller pins it (taskset -c 2) and holds the lock.
cd "$(dirname "$0")"
. ./corpora.sh
label=$1; name=$2; passes=${3:-1}
compiler=$PWD/results/$label/compiler
out=/dev/shm/claude-2877-o-$label
mkdir -p "$out"
eval "options=($(corpus_options "$name"))"
mapfile -t files < <(corpus_files "$name")
ran=0; failed=0
for ((p = 0; p < passes; p += 1)); do
    for f in "${files[@]}"; do
        b=${f##*/}
        "$compiler" -c "${options[@]}" "$f" -o "$out/${b%.c}.o" > /dev/null 2>&1 || failed=$((failed + 1))
        ran=$((ran + 1))
    done
done
echo "compiles $ran failed $failed"
