#!/bin/bash
# #785's qualification on the 9700X: head fa87e1a7 against its base, main e85d634a, each step its own hold of the
# shared lock: both builds, then main/head pairs with the order alternating by round: -c of the frozen sqlite3.c
# (perf stat, 11 runs a tree a round), its objects compared, benchmark-backend-source (Tier 0's validation among its
# rows) and benchmark-ir-source's lowering.
echo $$ > ~/buster-fast-bench/claude-785/queue.pid
cd ~/buster-fast-bench/claude-785
out=~/buster-fast-bench/claude-785/out
mkdir -p "$out"
lock()
{
    EXCLUSIVE_OWNER=claude-785 EXCLUSIVE_TITLE="IR: jump tables' successors (#785)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/785 ~/buster-fast-bench/exclusive.sh "$@"
}
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
order()
{
    if [ $(( $1 % 2 )) = 1 ]; then echo main head; else echo head main; fi
}
source_options="--predefines $corpus/provenance/gnu17-pinned-predefines.txt --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $corpus/headers/usr/lib/clang/23/include -isystem $corpus/headers/usr/local/include -isystem $corpus/headers/usr/include $corpus/sqlite/sqlite3.c"
for tree in head main; do
    lock bash -c "cd $tree && BUSTER_DEBUG_INFO=0 ./build.sh" > "$out/build-$tree.log" 2>&1
    echo "build $tree: $?" >> "$out/progress"
done
sqlite_options="-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$corpus/sqlite $corpus/sqlite/sqlite3.c"
script=""
for round in 1 2 3; do
    for tree in $(order $round); do
        script="$script cd ~/buster-fast-bench/claude-785/$tree && taskset -c 2 perf stat -r 11 -e cycles:u,instructions:u,task-clock -x, -o $out/pair-compile-$tree-$round.csv ./build/compiler $sqlite_options -o $out/pair-sqlite3-$tree.o; echo compile $tree $round \$?;"
    done
done
lock bash -c "$script" > "$out/pair-compile.log" 2>&1
echo "pair compile: $?" >> "$out/progress"
cmp "$out/pair-sqlite3-main.o" "$out/pair-sqlite3-head.o" > "$out/pair-object-cmp.log" 2>&1
echo "pair object cmp: $?" >> "$out/progress"
script=""
for round in 1 2 3; do
    for tree in $(order $round); do
        script="$script cd ~/buster-fast-bench/claude-785/$tree && taskset -c 2 ./build/compiler benchmark-backend-source $source_options > $out/pair-backend-source-$tree-$round.log 2>&1; echo backend-source $tree $round \$?;"
    done
done
lock bash -c "$script" > "$out/pair-backend-source.log" 2>&1
echo "pair backend-source: $?" >> "$out/progress"
script=""
for round in 1 2 3; do
    for tree in $(order $round); do
        script="$script cd ~/buster-fast-bench/claude-785/$tree && taskset -c 2 ./build/compiler benchmark-ir-source --only lower $source_options > $out/pair-ir-source-$tree-$round.log 2>&1; echo ir-source $tree $round \$?;"
    done
done
lock bash -c "$script" > "$out/pair-ir-source.log" 2>&1
echo "pair ir-source: $?" >> "$out/progress"
echo done >> "$out/progress"
