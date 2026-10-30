#!/bin/bash
# 9f's head (bf16 vectors' arithmetic, square roots and multiply-adds) against its parent, 9e2's head (base), with an A/A
# control (aa: a copy of base's executable): each tree's build under its own hold of the 9700X's lock; the frozen
# sqlite3.c's -c object by each, which must be the same; perf stat's user instructions, cycles and task-clock of
# -fsyntax-only and -c of sqlite3.c (no x86 builtin) and of -fsyntax-only of 9f's main.c, in three rounds whose order
# rotates; then the same sqlite3.c runs over the builds' code placements and fresh copies (main.c's own unit shifted, as
# abZ4's), each build's .rodata and .text, and the read-only data symbols whose total size differs (sizes.log). Every run
# takes the lock on its own and runs pinned to CPU 2.
set -u
export EXCLUSIVE_OWNER=claude-126-cloud EXCLUSIVE_TITLE="solve #126 (cloud session): 9f's head against its parent" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/126
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH BUSTER_ORACLE_CACHE
here=~/buster-fast-bench/claude-126-cloud/acC
export TMPDIR=$here/tmp
mkdir -p "$TMPDIR"
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
lower=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
check=(--clang-features "${lower[@]}")
cd "$here"
rm -rf base aa h9f && mkdir base h9f && tar xf base.tar -C base && tar xf h9f.tar -C h9f
for tree in base h9f; do
    (cd $tree && find . -type f | sort | xargs sha256sum) > sources-$tree.sha256
    (cd $tree && $lock env BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh > ../build_$tree.log 2>&1) || { echo "build $tree failed"; exit 1; }
    echo "built $tree: $(grep 'sources compiled' build_$tree.log)"
done
mkdir -p aa/build && cp base/build/compiler aa/build/compiler
mapfile -d '' -t main_flags < <(cd h9f && BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags)
for i in "${!main_flags[@]}"; do [ "${main_flags[$i]}" == "-Isrc" ] && main_flags[$i]="-I$here/h9f/src"; done
main=("${main_flags[@]}" "$here/h9f/src/buster/compiler/main.c")
order=(base aa h9f)
for tree in "${order[@]}"; do
    $lock taskset -c 2 $tree/build/compiler -c -o lower_$tree.o "${lower[@]}" > lower_$tree.log 2>&1
    echo "lower $tree status $?"
    $lock taskset -c 2 $tree/build/compiler --lanes 1 -fsyntax-only "${main[@]}" > main_$tree.log 2>&1
    echo "main $tree status $?"
done
cmp lower_base.o lower_aa.o && cmp lower_base.o lower_h9f.o && echo "lower objects identical"
for round in 1 2 3; do
    for i in "${!order[@]}"; do
        tree=${order[$(( (i + round - 1) % ${#order[@]} ))]}
        echo "== round $round tree $tree drive" >> perf.log
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -fsyntax-only "${check[@]}" 2>> perf.log >/dev/null
        echo "== round $round tree $tree lower" >> perf.log
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -c -o /dev/null "${lower[@]}" 2>> perf.log >/dev/null
        echo "== round $round tree $tree main" >> perf.log
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 5 taskset -c 2 $tree/build/compiler --lanes 1 -fsyntax-only "${main[@]}" 2>> perf.log >/dev/null
    done
done
echo "perf done"
sha256sum */build/compiler lower_*.o "$corpus/sqlite/sqlite3.c" "$corpus/provenance/gnu17-pinned-predefines.txt" h9f/src/buster/compiler/main.c > inputs.sha256
uname -r >> inputs.sha256
clang --version | head -1 >> inputs.sha256
shifts="0 768 1536 2304 3072 3840"
copies=/tmp/claude-126-acC
rm -rf whole && mkdir whole
for tree in base h9f; do
    (cd $tree && $lock env BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh shifts ../whole/$tree main.c $shifts > ../whole_$tree.log 2>&1) || { echo "main.c shifts $tree failed"; tail -3 whole_$tree.log; exit 1; }
    echo "shifted $tree's main.c: $(grep -c 'bytes later' whole_$tree.log) placements"
done
builds=()
for b in base:base h9f:h9f base-again:base; do
    for s in $shifts; do builds+=(--build "${b%%:*}" "whole/${b#*:}/compiler-$s"); done
done
rm -rf "$copies" && mkdir -p "$copies"
base/build/compiler ab --rounds 3 --cpu 2 --lock $lock base/build/compiler \
    -- time-runs --runs 3 --copies 3 --directory "$copies" "${builds[@]}" --list -c -o /dev/null "${lower[@]}" --list -fsyntax-only "${check[@]}" > whole.log 2>&1
echo "ab status $?"
rm -rf "$copies"
for tree in base aa h9f; do
    echo "$tree: $(readelf -SW $tree/build/compiler | awk '$2 == ".rodata" || $2 == ".text" {printf "%s %s %s  ", $2, $4, $6}')"
done
sha256sum whole/*/compiler-* > acC-whole.sha256
$lock "$here/sizes.sh" > sizes.log 2>&1
echo "sizes status $?"
echo done
