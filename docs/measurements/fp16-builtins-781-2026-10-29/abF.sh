#!/bin/bash
# buster14a/buster's batch 6 (#781: AVX512-FP16's builtins and half-precision vectors, head 0174c87) against its base,
# #772's 8792481, with an A/A control (aa: a copy of base's executable): each tree's build under its own hold of the
# 9700X's lock; the frozen sqlite3.c's -c object by each, which must be the same; then perf stat's user instructions and
# cycles of -fsyntax-only and -c of sqlite3.c (no vectors) and of -fsyntax-only of the head's main.c, in rotating
# rounds. Every run takes the lock on its own and runs pinned to CPU 2.
set -u
export EXCLUSIVE_OWNER=claude-126-cloud EXCLUSIVE_TITLE="solve #126 (cloud session): AVX512-FP16's builtins (#781), against #772" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/781
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH BUSTER_ORACLE_CACHE
here=~/buster-fast-bench/claude-126-cloud/abF
export TMPDIR=$here/tmp
mkdir -p "$TMPDIR"
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
lower=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
check=(--clang-features "${lower[@]}")
cd "$here"
for tree in base head; do
    (cd $tree && $lock env BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh > ../build_$tree.log 2>&1) || { echo "build $tree failed"; exit 1; }
    echo "built $tree: $(grep 'sources compiled' build_$tree.log)"
done
mkdir -p aa/build && cp base/build/compiler aa/build/compiler
mapfile -d '' -t main_flags < <(cd head && BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags)
for i in "${!main_flags[@]}"; do [ "${main_flags[$i]}" == "-Isrc" ] && main_flags[$i]="-I$here/head/src"; done
main=("${main_flags[@]}" "$here/head/src/buster/compiler/main.c")
for tree in base aa head; do
    $lock taskset -c 2 $tree/build/compiler -c -o lower_$tree.o "${lower[@]}" > lower_$tree.log 2>&1
    echo "lower $tree status $?"
    $lock taskset -c 2 $tree/build/compiler --lanes 1 -fsyntax-only "${main[@]}" > main_$tree.log 2>&1
    echo "main $tree status $?"
done
cmp lower_base.o lower_head.o && cmp lower_base.o lower_aa.o && echo "lower objects identical"
for round in 1 2 3; do
    for tree in base aa head; do
        echo "== round $round tree $tree drive" >> perf.log
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -fsyntax-only "${check[@]}" 2>> perf.log >/dev/null
        echo "== round $round tree $tree lower" >> perf.log
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -c -o /dev/null "${lower[@]}" 2>> perf.log >/dev/null
        echo "== round $round tree $tree main" >> perf.log
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 5 taskset -c 2 $tree/build/compiler --lanes 1 -fsyntax-only "${main[@]}" 2>> perf.log >/dev/null
    done
done
echo "perf done"
sha256sum base/build/compiler aa/build/compiler head/build/compiler lower_base.o lower_aa.o lower_head.o "$corpus/sqlite/sqlite3.c" "$corpus/provenance/gnu17-pinned-predefines.txt" head/src/buster/compiler/main.c > inputs.sha256
uname -r >> inputs.sha256
clang --version | head -1 >> inputs.sha256
echo done
