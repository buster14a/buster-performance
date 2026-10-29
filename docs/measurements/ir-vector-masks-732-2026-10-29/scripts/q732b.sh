#!/bin/bash
# #732's foundation (#748's work merged with main) on the 9700X: head 79da27b2 against main 5104e7e7, the final head against its merge base, each step its own
# hold of the shared lock: both builds, then main/head pairs alternating by round: benchmark-ir (the verifier and the
# derived arrays, whose vector batch now reads 32-bit result-type sets), benchmark-ir-lowering, benchmark-ir-source's
# verify and promote rows on the frozen sqlite3.c (the consumers' SIMD refusal scans every function first), and -c of
# sqlite3.c (perf stat, 11 runs a tree a round), whose objects must be the same.
echo $$ > ~/buster-fast-bench/claude-732/queue2.pid
until grep -q done ~/buster-fast-bench/claude-787/out-c/progress 2>/dev/null; do sleep 10; done
cd ~/buster-fast-bench/claude-732
out=~/buster-fast-bench/claude-732/out2
mkdir -p "$out"
lock()
{
    EXCLUSIVE_OWNER=claude-732 EXCLUSIVE_TITLE="IR vectors and masks (#732)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/732 ~/buster-fast-bench/exclusive.sh "$@"
}
order()
{
    if [ $(( $1 % 2 )) = 1 ]; then echo main head; else echo head main; fi
}
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
source_options="--predefines $corpus/provenance/gnu17-pinned-predefines.txt --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $corpus/headers/usr/lib/clang/23/include -isystem $corpus/headers/usr/local/include -isystem $corpus/headers/usr/include $corpus/sqlite/sqlite3.c"
for tree in head main; do
    lock bash -c "cd ${tree}2 && BUSTER_DEBUG_INFO=0 ./build.sh" > "$out/build-$tree.log" 2>&1
    echo "build $tree: $?" >> "$out/progress"
done
for round in 1 2 3; do
    script=""
    for tree in $(order $round); do
        script="$script cd ~/buster-fast-bench/claude-732/${tree}2 && taskset -c 2 ./build/compiler benchmark-ir > $out/pair-ir-$tree-$round.log 2>&1; echo ir $tree $round \$?; taskset -c 2 ./build/compiler benchmark-ir-lowering > $out/pair-lowering-$tree-$round.log 2>&1; echo lowering $tree $round \$?;"
    done
    lock bash -c "$script" >> "$out/pair-benchmarks.log" 2>&1
    echo "pair benchmarks $round: $?" >> "$out/progress"
done
for round in 1 2 3; do
    script=""
    for tree in $(order $round); do
        for v in verify verify-scalar promote; do
            script="$script cd ~/buster-fast-bench/claude-732/${tree}2 && taskset -c 2 ./build/compiler benchmark-ir-source --only $v $source_options > $out/pair-source-$v-$tree-$round.log 2>&1; echo source $v $tree $round \$?;"
        done
    done
    lock bash -c "$script" >> "$out/pair-source.log" 2>&1
    echo "pair source $round: $?" >> "$out/progress"
done
sqlite_options="-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$corpus/sqlite $corpus/sqlite/sqlite3.c"
script=""
for round in 1 2 3; do
    for tree in $(order $round); do
        script="$script cd ~/buster-fast-bench/claude-732/${tree}2 && taskset -c 2 perf stat -r 11 -e cycles:u,instructions:u,task-clock -x, -o $out/pair-compile-$tree-$round.csv ./build/compiler $sqlite_options -o $out/pair-sqlite3-$tree.o; echo compile $tree $round \$?;"
    done
done
lock bash -c "$script" > "$out/pair-compile.log" 2>&1
echo "pair compile: $?" >> "$out/progress"
cmp "$out/pair-sqlite3-main.o" "$out/pair-sqlite3-head.o" > "$out/pair-object-cmp.log" 2>&1
echo "pair object cmp: $?" >> "$out/progress"
echo done >> "$out/progress"
