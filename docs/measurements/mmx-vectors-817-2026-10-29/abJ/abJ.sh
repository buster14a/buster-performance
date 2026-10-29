#!/bin/bash
# #817's cost fix and variants of its vector conditional's route, against main 74af993 (base) with an A/A control (aa:
# a copy of base's executable): head is the fix as committed (499c1ce: the logical operators' code shared through
# check_lower_logical, the vector route's test extended to ?:); r3 shares it by the value's pointer and tests for a vector
# ?: inside the logical branch; r4 keeps main's inline logical code with a vector ?: branch of its own before it; b keeps
# main's inline code with the extended route; c is the merge 63e99bb with its old test removed (bit casts then splat, a
# reference only). Each tree's build under its own hold of the 9700X's lock; the frozen sqlite3.c's -c object by each,
# which must be the same; then perf stat's user instructions and cycles of -c of sqlite3.c, 11 runs, in two rounds whose
# order rotates. Every run takes the lock on its own and runs pinned to CPU 2.
set -u
export EXCLUSIVE_OWNER=claude-126-cloud EXCLUSIVE_TITLE="solve #126 (cloud session): #817's cost fix, its vector conditional's variants" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/817
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH BUSTER_ORACLE_CACHE
here=~/buster-fast-bench/claude-126-cloud/abJ
export TMPDIR=$here/tmp
mkdir -p "$TMPDIR"
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
lower=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
cd "$here"
tar xf base.tar && tar xf head.tar
for v in r3 r4 b c; do
    rm -rf $v && mkdir $v && tar xf head.tar -C $v --strip-components=1 && tar xf var-$v.tar -C $v
done
for tree in base head r3 r4 b c; do
    (cd $tree && find . -type f | sort | xargs sha256sum) > sources-$tree.sha256
    (cd $tree && $lock env BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh > ../build_$tree.log 2>&1) || { echo "build $tree failed"; exit 1; }
    echo "built $tree: $(grep 'sources compiled' build_$tree.log)"
done
mkdir -p aa/build && cp base/build/compiler aa/build/compiler
order=(base aa head r3 r4 b c)
for tree in "${order[@]}"; do
    $lock taskset -c 2 $tree/build/compiler -c -o lower_$tree.o "${lower[@]}" > lower_$tree.log 2>&1
    echo "lower $tree status $?"
done
for tree in "${order[@]}"; do cmp lower_base.o lower_$tree.o || echo "lower $tree differs"; done
for round in 1 2; do
    for i in "${!order[@]}"; do
        tree=${order[$(( (i + round - 1) % ${#order[@]} ))]}
        echo "== round $round tree $tree lower" >> perf.log
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -c -o /dev/null "${lower[@]}" 2>> perf.log >/dev/null
    done
done
echo "perf done"
sha256sum */build/compiler lower_*.o "$corpus/sqlite/sqlite3.c" "$corpus/provenance/gnu17-pinned-predefines.txt" > inputs.sha256
uname -r >> inputs.sha256
clang --version | head -1 >> inputs.sha256
echo done
