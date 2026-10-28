#!/bin/bash
# #619's head with the walk's guard on the reader's section attributes (head3) against main (base, 4165454) and the
# guard before it (head2, 572471f): the build under its own hold of the 9700X's lock, the frozen sqlite3.c's -c object
# against main's, then perf stat of -fsyntax-only and -c pinned to CPU 2 in rotating rounds, each run under its own hold.
set -u
export EXCLUSIVE_OWNER=claude-126-cloud EXCLUSIVE_TITLE="solve #126 (cloud session): #619's checker A/B, the attribute guard" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/619
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
(cd head3 && $lock env BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh > ../build_head3.log 2>&1) || { echo "build head3 failed"; exit 1; }
echo "built head3: $(grep 'sources compiled' build_head3.log)"
flags=$(sed -n 's/^flags=(\(.*\))$/\1/p' head3/build.sh)
(cd head3 && $lock taskset -c 2 ./build/compiler -fsyntax-only $flags src/buster/compiler/main.c > ../main_c_head3.log 2>&1)
echo "main.c head3 status $? $(grep -v "$filter" main_c_head3.log | grep -m1 error)"
$lock taskset -c 2 head3/build/compiler -c -o lower_head3.o "${lower[@]}" > lower_head3.log 2>&1
echo "lower head3 status $?"
cmp lower_base.o lower_head3.o && echo "lower objects identical"
for round in 1 2 3; do
    for tree in base head2 head3; do
        echo "== round $round tree $tree drive" >> perf3.log
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -fsyntax-only "${check[@]}" 2>&1 >/dev/null | grep -v "$filter" >> perf3.log
        echo "== round $round tree $tree lower" >> perf3.log
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -c -o /dev/null "${lower[@]}" 2>&1 >/dev/null | grep -v "$filter" >> perf3.log
    done
done
echo "perf3 done"
