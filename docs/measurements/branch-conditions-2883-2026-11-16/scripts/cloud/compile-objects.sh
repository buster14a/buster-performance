#!/bin/bash
# compile-all.sh COMPILER CORPUS OUT: the corpus's -c compiles, a process a file, in the list's order, the objects
# written to OUT. Prints how many compiles there were and how many failed. A caller that times it pins it and holds
# the lock.
cd "$(dirname "$0")"
. ./corpora.sh
compiler=$1; name=$2; out=$3
mkdir -p "$out"
eval "options=($(corpus_options "$name"))"
mapfile -t files < <(corpus_files "$name")
ran=0; failed=0
for f in "${files[@]}"; do
    b=${f##*/}
    "$compiler" -c "${options[@]}" "$f" -o "$out/${b%.c}.o" > /dev/null 2>&1 || failed=$((failed + 1))
    ran=$((ran + 1))
done
echo "$name compiles $ran failed $failed"
