#!/bin/bash
# #126's atomics lowering (abd6: #496's c558ef52 against the branch's 2665c26c): the atomic suites and test-checker against
# clang 23.1.1, then the frozen sqlite3.c's typed checking in the process, the whole -fsyntax-only driver, and -c without
# clang's feature answers (its atomics off, so both trees write it), each build and run under its own hold of the lock,
# pinned to CPU 2. With clang's answers its atomics are on: -c of that once, by the head.
set -u
export EXCLUSIVE_OWNER=claude-126 EXCLUSIVE_TITLE="solve #126: atomics lowering on #496's head, tests and A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/148
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
source=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
driver=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
lower=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
cd ~/buster-fast-bench/solve-126-claude/abd6
for tree in base head; do
    (cd $tree && $lock env BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh > ../build_$tree.log 2>&1) || { echo "build $tree failed"; exit 1; }
    echo "built $tree"
done
for t in test-builtin-atomic-rmw-helpers test-check-builtins-atomic-rmw test-check-builtins-atomic test-builtin-atomic-helpers; do
    $lock ./head/build/compiler $t > test_$t.log 2>&1
    echo "$t status $? $(tail -1 test_$t.log)"
done
$lock ./head/build/compiler test-checker --seed 133 > test_checker.log 2>&1
echo "test-checker status $? $(grep -E 'checks, [0-9]+ failures' test_checker.log | tail -1)"
for tree in base head; do
    $lock taskset -c 2 $tree/build/compiler -fsyntax-only "${driver[@]}" > drive_$tree.log 2>&1
    echo "drive $tree status $?"
    $lock taskset -c 2 $tree/build/compiler -c -o lower_$tree.o "${lower[@]}" > lower_$tree.log 2>&1
    echo "lower $tree status $?"
done
cmp lower_base.o lower_head.o && echo "lower objects identical"
$lock taskset -c 2 head/build/compiler -c -o atomic_head.o "${driver[@]}" > atomic_head.log 2>&1
echo "head -c with sqlite's atomics status $?"
./head/build/compiler ab --rounds 5 --cpu 2 --lock $lock base head -- benchmark-checker-source "${source[@]}" > ab_source.log 2>&1
echo "ab source status $?"
./head/build/compiler ab --rounds 5 --cpu 2 --lock $lock base head -- time-runs --runs 21 --list -fsyntax-only "${driver[@]}" > ab_driver.log 2>&1
echo "ab driver status $?"
./head/build/compiler ab --rounds 5 --cpu 2 --lock $lock base head -- time-runs --runs 11 --list -c -o /dev/null "${lower[@]}" > ab_lower.log 2>&1
echo "ab lower status $?"
for round in 1 2 3; do
    for tree in base head; do
        echo "== round $round tree $tree driver" >> perf.log
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -fsyntax-only "${driver[@]}" 2>&1 >/dev/null | grep -v "^exclusive.sh:\|^  title:\|^  link:\|^  pull request:" >> perf.log
        echo "== round $round tree $tree lower" >> perf.log
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -c -o /dev/null "${lower[@]}" 2>&1 >/dev/null | grep -v "^exclusive.sh:\|^  title:\|^  link:\|^  pull request:" >> perf.log
    done
done
echo "perf done"
echo done
