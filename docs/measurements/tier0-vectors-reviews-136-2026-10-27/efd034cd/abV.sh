#!/bin/bash
# #136's vector class in Tier 0 (abv13: main ad408cf2 against the branch's efd034cd: #556's review fix, main merged): what it costs the code
# without vectors. benchmark-backend's generated programs (both paths' instructions and time per entry, 21 passes each),
# and -c of the frozen sqlite3.c (the whole compile, Tier 0 among it), each build and run under its own hold of the lock,
# pinned to CPU 2. The head's test-tier0 and its cross-check first.
set -u
export EXCLUSIVE_OWNER=claude-126 EXCLUSIVE_TITLE="solve #126: Tier 0's vector class A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/136
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
lower=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
cd ~/buster-fast-bench/solve-126-claude/abv13
for tree in base head; do
    (cd $tree && $lock env BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh > ../build_$tree.log 2>&1) || { echo "build $tree failed"; exit 1; }
    echo "built $tree"
done
$lock taskset -c 2 head/build/compiler test-tier0 > test_tier0.log 2>&1
echo "test-tier0 status $? $(tail -1 test_tier0.log)"
$lock taskset -c 2 head/build/compiler test-tier0 --cross-check > test_tier0_cross.log 2>&1
echo "test-tier0 --cross-check status $? $(tail -1 test_tier0_cross.log)"
for tree in base head; do
    $lock taskset -c 2 $tree/build/compiler -c -o lower_$tree.o "${lower[@]}" > lower_$tree.log 2>&1
    echo "lower $tree status $?"
done
cmp lower_base.o lower_head.o && echo "lower objects identical"
./head/build/compiler ab --rounds 5 --cpu 2 --lock $lock base head -- benchmark-backend > ab_backend.log 2>&1
echo "ab backend status $?"
./head/build/compiler ab --rounds 5 --cpu 2 --lock $lock base head -- time-runs --runs 11 --list -c -o /dev/null "${lower[@]}" > ab_lower.log 2>&1
echo "ab lower status $?"
for round in 1 2 3; do
    for tree in base head; do
        echo "== round $round tree $tree lower" >> perf.log
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -c -o /dev/null "${lower[@]}" 2>&1 >/dev/null | grep -v "^exclusive.sh:\|^  title:\|^  link:\|^  pull request:" >> perf.log
    done
done
echo "perf done"
echo done
