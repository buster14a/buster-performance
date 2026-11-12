#!/bin/bash
# The function maps of the three largest units, from their unoptimized bitcode (compile.sh's `unoptimized`), to be run
# inside the lock: tools/function_files, then reach.py's product, rest and test lists. Not a timing.
set -eu
d=$HOME/buster-fast-bench/2040-claude
mkdir -p "$d/results/maps"
for unit in "$@"; do
    "$d/tools/function_files" "$d/scratch/compile/$unit-unoptimized.bc" "$d/results/maps/$unit.functions.tsv" "$d/results/maps/$unit.edges.tsv"
    python3 "$d/tools/reach.py" "$d/results/maps/$unit.functions.tsv" "$d/results/maps/$unit.edges.tsv" "$d/results/maps/$unit" > "$d/results/maps/$unit.reach.txt"
    cp "$d/results/maps/$unit.tests.csv" "$d/scratch/$unit.tests.csv"
    cat "$d/results/maps/$unit.reach.txt"
done
