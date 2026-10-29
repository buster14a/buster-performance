#!/bin/bash
# #772's head (6ab01f9) against the same with the attribute string's reading memoized and the bodies' search bounded to
# the keys' objects (head2: abT2.patch), with an A/A control (head's executable copied): head2's build under its own hold
# of the 9700X's lock; the frozen sqlite3.c's -c object by each, which must be the same; then perf stat's user
# instructions and cycles of -fsyntax-only of the head's main.c (5,344 target attributes) and of the frozen sqlite3.c,
# in rotating rounds. Every run takes the lock on its own and runs pinned to CPU 2.
set -u
export EXCLUSIVE_OWNER=claude-126-cloud EXCLUSIVE_TITLE="solve #126 (cloud session): a function's target attribute, against #771" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/772
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH BUSTER_ORACLE_CACHE
here=~/buster-fast-bench/claude-126-cloud/abT
export TMPDIR=$here/tmp
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
lower=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
check=(--clang-features "${lower[@]}")
cd "$here"
rm -rf head2 aa2 && cp -r head head2 && rm -rf head2/build && (cd head2 && patch -p1 -s < ../abT2.patch) || { echo "patch failed"; exit 1; }
(cd head2 && $lock env BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh > ../build_head2.log 2>&1) || { echo "build head2 failed"; exit 1; }
echo "built head2: $(grep 'sources compiled' build_head2.log)"
mkdir -p aa2/build && cp head/build/compiler aa2/build/compiler
mapfile -d '' -t main_flags < <(cd head && BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags)
for i in "${!main_flags[@]}"; do [ "${main_flags[$i]}" == "-Isrc" ] && main_flags[$i]="-I$here/head/src"; done
main=("${main_flags[@]}" "$here/head/src/buster/compiler/main.c")
for tree in head2; do
    $lock taskset -c 2 $tree/build/compiler -c -o lower_$tree.o "${lower[@]}" > lower_$tree.log 2>&1
    echo "lower $tree status $?"
    $lock taskset -c 2 $tree/build/compiler --lanes 1 -fsyntax-only "${main[@]}" > main_$tree.log 2>&1
    echo "main $tree status $?"
done
cmp lower_head.o lower_head2.o && echo "lower objects identical"
: > perf2.log
for round in 1 2 3; do
    for tree in head aa2 head2; do
        echo "== round $round tree $tree drive" >> perf2.log
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -fsyntax-only "${check[@]}" 2>> perf2.log >/dev/null
        echo "== round $round tree $tree main" >> perf2.log
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 5 taskset -c 2 $tree/build/compiler --lanes 1 -fsyntax-only "${main[@]}" 2>> perf2.log >/dev/null
    done
done
sha256sum head/build/compiler aa2/build/compiler head2/build/compiler lower_head.o lower_head2.o abT2.patch > inputs2.sha256
echo "perf2 done"
