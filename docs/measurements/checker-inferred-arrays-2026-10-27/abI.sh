#!/bin/bash
# The inferred array's operators (abi10: main 51bf882b against f92b7505): test-checker against clang 23.1.1, then the
# frozen sqlite3.c's -fsyntax-only (clang's feature answers), perf stat -r 11 in three rounds, each build and run under its
# own hold of the lock, pinned to CPU 2.
set -u
export EXCLUSIVE_OWNER=claude-126 EXCLUSIVE_TITLE="solve #126: an inferred array's operators, A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/133
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
driver=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
cd ~/buster-fast-bench/solve-126-claude/abi10
for tree in base head; do
    (cd $tree && $lock env BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh > ../build_$tree.log 2>&1) || { echo "build $tree failed"; exit 1; }
    echo "built $tree"
done
$lock ./head/build/compiler test-checker > test_checker.log 2>&1
echo "test-checker status $? $(grep -E 'checks, [0-9]+ failures' test_checker.log | tail -1)"
for tree in base head; do
    $lock taskset -c 2 $tree/build/compiler -fsyntax-only "${driver[@]}" > drive_$tree.log 2>&1
    echo "drive $tree status $?"
done
for round in 1 2 3; do
    for tree in base head; do
        echo "== round $round tree $tree driver" >> perf.log
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -fsyntax-only "${driver[@]}" 2>&1 >/dev/null | grep -v "^exclusive.sh:\|^  title:\|^  link:\|^  pull request:" >> perf.log
    done
done
echo "perf done"
echo done
