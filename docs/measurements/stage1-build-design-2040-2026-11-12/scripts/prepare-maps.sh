#!/bin/bash
# One utility run inside the lock, not a timing: the record's C tools built against the host's LLVM, the three largest
# units stopped before LLVM's optimizer (compile.sh's `unoptimized`; the front end's time is read from the traces
# instead), and function_files' and reach.py's maps of them, with the list of their test functions for the
# tests-optnone variants (scratch/UNIT.tests.csv and their union, scratch/all.tests.csv).
set -eu
d=$HOME/buster-fast-bench/2040-claude
"$d/scripts/build-tools.sh"
units="main_unit_checker main_unit_backend main_unit_frontend"
for unit in $units; do "$d/scripts/compile.sh" src "$unit" unoptimized; done
# shellcheck disable=SC2086
"$d/scripts/maps.sh" $units
cat "$d/results/maps/main_unit_checker.tests.csv" "$d/results/maps/main_unit_backend.tests.csv" "$d/results/maps/main_unit_frontend.tests.csv" | sort -u > "$d/scratch/all.tests.csv"
wc -l "$d/scratch/all.tests.csv"
