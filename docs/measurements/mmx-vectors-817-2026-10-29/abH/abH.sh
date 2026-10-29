#!/bin/bash
# #817's -c instruction cost: head ff2b8e0, and two variants of it (v1: the bit-cast test behind an inline class test; v2:
# the bit-cast test removed), against main 5655370 (abG's base build), its A/A copy (aa) and abG's head 588fb14. Each new
# tree's build under its own hold of the 9700X's lock; the frozen sqlite3.c's -c object by each, which must be the same;
# then perf stat's user instructions and cycles of -fsyntax-only and -c of sqlite3.c in rotating rounds. Every run takes
# the lock on its own and runs pinned to CPU 2.
set -u
export EXCLUSIVE_OWNER=claude-126-cloud EXCLUSIVE_TITLE="solve #126 (cloud session): #817's -c instruction cost, variants" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/817
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH BUSTER_ORACLE_CACHE
here=~/buster-fast-bench/claude-126-cloud/abH
abG=~/buster-fast-bench/claude-126-cloud/abG
export TMPDIR=$here/tmp
mkdir -p "$TMPDIR"
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
lower=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
check=(--clang-features "${lower[@]}")
cd "$here"
for tree in head2 v1 v2; do
    tar -xf $tree.tar
    (cd $tree && find . -path ./build -prune -o -type f -print | LC_ALL=C sort | xargs -d '\n' sha256sum) > sources-$tree.sha256
    (cd $tree && $lock env BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh > ../build_$tree.log 2>&1) || { echo "build $tree failed"; exit 1; }
    echo "built $tree: $(grep 'sources compiled' build_$tree.log)"
done
mkdir -p base/build aa/build head/build
cp $abG/base/build/compiler base/build/compiler
cp $abG/base/build/compiler aa/build/compiler
cp $abG/head/build/compiler head/build/compiler
trees="base aa head head2 v1 v2"
for tree in $trees; do
    $lock taskset -c 2 $tree/build/compiler -c -o lower_$tree.o "${lower[@]}" > lower_$tree.log 2>&1
    echo "lower $tree status $?"
done
same=1
for tree in $trees; do cmp lower_base.o lower_$tree.o || same=0; done
[ $same = 1 ] && echo "lower objects identical"
order=($trees)
for round in 1 2 3; do
    for i in "${!order[@]}"; do
        tree=${order[$(( (i + round - 1) % ${#order[@]} ))]}
        echo "== round $round tree $tree drive" >> perf.log
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -fsyntax-only "${check[@]}" 2>> perf.log >/dev/null
        echo "== round $round tree $tree lower" >> perf.log
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -c -o /dev/null "${lower[@]}" 2>> perf.log >/dev/null
    done
done
echo "perf done"
sha256sum base/build/compiler aa/build/compiler head/build/compiler head2/build/compiler v1/build/compiler v2/build/compiler lower_*.o "$corpus/sqlite/sqlite3.c" "$corpus/provenance/gnu17-pinned-predefines.txt" > inputs.sha256
uname -r >> inputs.sha256
clang --version | head -1 >> inputs.sha256
echo done
