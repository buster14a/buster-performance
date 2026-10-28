#!/bin/bash
# #619 parts 1 and 3 (main 4165454 against the branch's head): the checker's #pragma clang section and optimize, and
# ucmpd128_mask. Each build and run under its own hold of the 9700X's lock, pinned to CPU 2: the head's tests, main.c's
# check by both trees, then -fsyntax-only and -c of the frozen sqlite3.c, whose objects must be identical, by ab's
# rotating rounds of time-runs and by perf stat.
set -u
export EXCLUSIVE_OWNER=claude-126-cloud EXCLUSIVE_TITLE="solve #126 (cloud session): #619's checker A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/619
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH
export TMPDIR=~/buster-fast-bench/claude-126-cloud/ab619/tmp
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
lower=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
check=(--clang-features "${lower[@]}")
filter="^exclusive.sh:\|^  title:\|^  link:\|^  pull request:"
cd ~/buster-fast-bench/claude-126-cloud/ab619
for tree in base head; do
    (cd $tree && $lock env BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh > ../build_$tree.log 2>&1) || { echo "build $tree failed"; exit 1; }
    echo "built $tree: $(grep 'sources compiled' build_$tree.log)"
done
for t in "test-checker-driver --executable ./build/compiler" "test-checker-deferred" "test-check-builtins-x86" "test-builtin-intrinsic-catalog" "test-checker --seed 133"; do
    name=$(echo "$t" | cut -d' ' -f1)
    (cd head && $lock taskset -c 2 ./build/compiler $t > ../$name.log 2>&1)
    echo "$name status $? $(grep -v "$filter" $name.log | tail -1)"
done
flags=$(sed -n 's/^flags=(\(.*\))$/\1/p' head/build.sh)
for tree in base head; do
    (cd $tree && $lock taskset -c 2 ./build/compiler -fsyntax-only $flags src/buster/compiler/main.c > ../main_c_$tree.log 2>&1)
    echo "main.c $tree status $? $(grep -v "$filter" main_c_$tree.log | grep -m1 error)"
done
for tree in base head; do
    $lock taskset -c 2 $tree/build/compiler -c -o lower_$tree.o "${lower[@]}" > lower_$tree.log 2>&1
    echo "lower $tree status $?"
    $lock taskset -c 2 $tree/build/compiler -fsyntax-only "${check[@]}" > drive_$tree.log 2>&1
    echo "drive $tree status $?"
done
cmp lower_base.o lower_head.o && echo "lower objects identical"
./head/build/compiler ab --rounds 5 --cpu 2 --lock $lock base head -- time-runs --runs 11 --list -fsyntax-only "${check[@]}" --list -c -o /dev/null "${lower[@]}" > ab.log 2>&1
echo "ab status $?"
for round in 1 2 3; do
    for tree in base head; do
        echo "== round $round tree $tree drive" >> perf.log
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -fsyntax-only "${check[@]}" 2>&1 >/dev/null | grep -v "$filter" >> perf.log
        echo "== round $round tree $tree lower" >> perf.log
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -c -o /dev/null "${lower[@]}" 2>&1 >/dev/null | grep -v "$filter" >> perf.log
    done
done
echo "perf done"
