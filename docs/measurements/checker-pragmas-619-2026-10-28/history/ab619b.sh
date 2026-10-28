#!/bin/bash
# #619's head after the walk's guard (572471f) against the same main (4165454): the build under its own hold of the
# 9700X's lock, then -fsyntax-only and -c of the frozen sqlite3.c pinned to CPU 2, whose objects must be identical to
# main's, by ab's rotating rounds of time-runs and by perf stat, each run under its own hold.
set -u
export EXCLUSIVE_OWNER=claude-126-cloud EXCLUSIVE_TITLE="solve #126 (cloud session): #619's checker A/B, after the guard" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/619
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
(cd head2 && $lock env BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh > ../build_head2.log 2>&1) || { echo "build head2 failed"; exit 1; }
echo "built head2: $(grep 'sources compiled' build_head2.log)"
flags=$(sed -n 's/^flags=(\(.*\))$/\1/p' head2/build.sh)
(cd head2 && $lock taskset -c 2 ./build/compiler -fsyntax-only $flags src/buster/compiler/main.c > ../main_c_head2.log 2>&1)
echo "main.c head2 status $? $(grep -v "$filter" main_c_head2.log | grep -m1 error)"
$lock taskset -c 2 head2/build/compiler -c -o lower_head2.o "${lower[@]}" > lower_head2.log 2>&1
echo "lower head2 status $?"
cmp lower_base.o lower_head2.o && echo "lower objects identical"
./head2/build/compiler ab --rounds 5 --cpu 2 --lock $lock base head2 -- time-runs --runs 11 --list -fsyntax-only "${check[@]}" --list -c -o /dev/null "${lower[@]}" > ab2.log 2>&1
echo "ab2 status $?"
for round in 1 2 3; do
    for tree in base head2; do
        echo "== round $round tree $tree drive" >> perf2.log
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -fsyntax-only "${check[@]}" 2>&1 >/dev/null | grep -v "$filter" >> perf2.log
        echo "== round $round tree $tree lower" >> perf2.log
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -c -o /dev/null "${lower[@]}" 2>&1 >/dev/null | grep -v "$filter" >> perf2.log
    done
done
echo "perf2 done"
