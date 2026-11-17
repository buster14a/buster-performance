#!/usr/bin/env bash
# Mutation runner for #2791: each mutant is applied to the copy tree, built incrementally, and must make
# test-tier1-select or test-tier1-emit fail; it is reverted after its run either way.
set -u
cd "$(dirname "$0")/tree" || exit 1
log=../results.txt
: > "$log"
./build.sh --config Develop > ../build-base.log 2>&1 || { echo "base build failed" >> "$log"; exit 1; }
./build/compiler test-tier1-select > ../base-select.log 2>&1; s=$?
./build/compiler test-tier1-emit > ../base-emit.log 2>&1; e=$?
echo "base select=$s emit=$e" >> "$log"
n=$(python3 ../mutants.py count)
for k in $(seq 0 $((n - 1))); do
    name=$(python3 ../mutants.py name "$k")
    python3 ../mutants.py apply "$k" || { echo "$name: apply failed" >> "$log"; continue; }
    if ./build.sh --config Develop > "../build-$k.log" 2>&1; then
        timeout 600 ./build/compiler test-tier1-select > "../select-$k.log" 2>&1; s=$?
        timeout 600 ./build/compiler test-tier1-emit > "../emit-$k.log" 2>&1; e=$?
        if [ "$s" -ne 0 ] || [ "$e" -ne 0 ]; then verdict=killed; else verdict=SURVIVED; fi
        echo "$name: select=$s emit=$e $verdict" >> "$log"
    else
        echo "$name: build failed (see build-$k.log)" >> "$log"
    fi
    python3 ../mutants.py revert "$k" || { echo "$name: revert failed" >> "$log"; exit 1; }
done
./build.sh --config Develop > ../build-final.log 2>&1
echo "done" >> "$log"
