#!/bin/bash
# run.sh TREE: each of mutants.py's mutants in TREE (a copy of the tree, built once): apply, build, run test-tier1-select,
# test-tier1-emit and the driver's pattern test (each under a timeout), revert and check the tree is clean again.
set -u
here=$(cd "$(dirname "$0")" && pwd)
cd "$1"
clang -std=c17 -O2 -Wall -Wextra -Werror -fno-strict-aliasing tests/driver/tier1_patterns.c -o build/test-driver-tier1-patterns || exit 1
count=$(python3 $here/mutants.py names | wc -l)
for n in $(seq 0 $((count - 1))); do
    name=$(python3 $here/mutants.py names | sed -n "$((n + 1))p")
    python3 $here/mutants.py apply $n > /dev/null || { echo "$name: apply failed"; exit 1; }
    if nice -n 10 ./build.sh > mutant-$name-build.log 2>&1; then
        r1=$(timeout 600 ./build/compiler test-tier1-select > mutant-$name-select.log 2>&1; echo $?)
        r2=$(timeout 900 ./build/compiler test-tier1-emit > mutant-$name-emit.log 2>&1; echo $?)
        r3=$(timeout 600 ./build/test-driver-tier1-patterns build/compiler "$(command -v clang)" > mutant-$name-patterns.log 2>&1; echo $?)
        echo "$name: select=$r1 emit=$r2 patterns=$r3 $([ $r1$r2$r3 = 000 ] && echo SURVIVED || echo killed)"
    else
        echo "$name: build failed"
    fi
    python3 $here/mutants.py revert $n > /dev/null || { echo "$name: revert failed"; exit 1; }
    git diff --quiet || { echo "tree not clean after $name"; exit 1; }
done
echo done
