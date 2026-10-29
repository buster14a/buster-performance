#!/bin/bash
# #784's final head 8d8b53c3 (with the x86 semantics' tables shared too) against its merge base, main e9e542b4: both
# builds, the checker's unit compiled alone (three rounds, alternating) and -c of the frozen sqlite3.c (perf stat, 11
# runs a tree a round), its objects compared; each step its own hold of the shared lock.
echo $$ > ~/buster-fast-bench/claude-784/queue-b.pid
until grep -q done ~/buster-fast-bench/claude-732/out2/progress 2>/dev/null; do sleep 10; done
cd ~/buster-fast-bench/claude-784
out=~/buster-fast-bench/claude-784/out-b
mkdir -p "$out" ~/buster-fast-bench/claude-784/tmp
lock()
{
    EXCLUSIVE_OWNER=claude-784 EXCLUSIVE_TITLE="IR commands in the backend unit (#784)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/784 ~/buster-fast-bench/exclusive.sh "$@"
}
order()
{
    if [ $(( $1 % 2 )) = 1 ]; then echo main3 head3; else echo head3 main3; fi
}
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
for tree in head3 main3; do
    lock bash -c "cd $tree && BUSTER_DEBUG_INFO=0 ./build.sh" > "$out/build-$tree.log" 2>&1
    echo "build $tree: $?" >> "$out/progress"
done
for round in 1 2 3; do
    script=""
    for tree in $(order $round); do
        script="$script cd ~/buster-fast-bench/claude-784/$tree && mapfile -d '' -t flags < <(BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags) && s=\$(date +%s%N) && taskset -c 2 clang -c src/buster/compiler/main_unit_checker.c -o ~/buster-fast-bench/claude-784/tmp/checker-$tree.o \"\${flags[@]}\" && e=\$(date +%s%N) && echo \"checker unit $tree $round: \$(( (e - s) / 1000000 )) ms\";"
    done
    lock bash -c "$script" >> "$out/pair-checker-unit.log" 2>&1
    echo "pair checker unit $round: $?" >> "$out/progress"
done
sqlite_options="-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$corpus/sqlite $corpus/sqlite/sqlite3.c"
script=""
for round in 1 2 3; do
    for tree in $(order $round); do
        script="$script cd ~/buster-fast-bench/claude-784/$tree && taskset -c 2 perf stat -r 11 -e cycles:u,instructions:u,task-clock -x, -o $out/pair-compile-$tree-$round.csv ./build/compiler $sqlite_options -o $out/pair-sqlite3-$tree.o; echo compile $tree $round \$?;"
    done
done
lock bash -c "$script" > "$out/pair-compile.log" 2>&1
echo "pair compile: $?" >> "$out/progress"
cmp "$out/pair-sqlite3-main3.o" "$out/pair-sqlite3-head3.o" > "$out/pair-object-cmp.log" 2>&1
echo "pair object cmp: $?" >> "$out/progress"
echo done >> "$out/progress"
