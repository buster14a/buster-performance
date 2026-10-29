#!/bin/bash
# 9d's head (AVX10.2's saturating conversions, bf16 operations and 8-bit floats, MOVRS's and AVX512-BMM's builtins)
# against its parent, #895's head (base), with an A/A control (aa: a copy of base's executable): each tree's build under
# its own hold of the 9700X's lock; the frozen sqlite3.c's -c object by each, which must be the same; then perf stat's
# user instructions, cycles and task-clock of -fsyntax-only and -c of sqlite3.c (no x86 builtin) and of -fsyntax-only of
# 9d's main.c, in three rounds whose order rotates. Every run takes the lock on its own and runs pinned to CPU 2.
set -u
export EXCLUSIVE_OWNER=claude-126-cloud EXCLUSIVE_TITLE="solve #126 (cloud session): 9d's head against its parent" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/126
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH BUSTER_ORACLE_CACHE
here=~/buster-fast-bench/claude-126-cloud/abZ
export TMPDIR=$here/tmp
mkdir -p "$TMPDIR"
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
lower=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
check=(--clang-features "${lower[@]}")
cd "$here"
rm -rf base aa h9d && mkdir base h9d && tar xf base.tar -C base && tar xf h9d.tar -C h9d
for tree in base h9d; do
    (cd $tree && find . -type f | sort | xargs sha256sum) > sources-$tree.sha256
    (cd $tree && $lock env BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh > ../build_$tree.log 2>&1) || { echo "build $tree failed"; exit 1; }
    echo "built $tree: $(grep 'sources compiled' build_$tree.log)"
done
mkdir -p aa/build && cp base/build/compiler aa/build/compiler
mapfile -d '' -t main_flags < <(cd h9d && BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags)
for i in "${!main_flags[@]}"; do [ "${main_flags[$i]}" == "-Isrc" ] && main_flags[$i]="-I$here/h9d/src"; done
main=("${main_flags[@]}" "$here/h9d/src/buster/compiler/main.c")
order=(base aa h9d)
for tree in "${order[@]}"; do
    $lock taskset -c 2 $tree/build/compiler -c -o lower_$tree.o "${lower[@]}" > lower_$tree.log 2>&1
    echo "lower $tree status $?"
    $lock taskset -c 2 $tree/build/compiler --lanes 1 -fsyntax-only "${main[@]}" > main_$tree.log 2>&1
    echo "main $tree status $?"
done
cmp lower_base.o lower_aa.o && cmp lower_base.o lower_h9d.o && echo "lower objects identical"
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
sha256sum */build/compiler lower_*.o "$corpus/sqlite/sqlite3.c" "$corpus/provenance/gnu17-pinned-predefines.txt" h9d/src/buster/compiler/main.c > inputs.sha256
uname -r >> inputs.sha256
clang --version | head -1 >> inputs.sha256
echo done
