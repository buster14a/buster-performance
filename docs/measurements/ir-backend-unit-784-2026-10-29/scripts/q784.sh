#!/bin/bash
# #784's qualification on the 9700X: head d1c21464 against its base, main d11a91d2, each step its own hold of the shared
# lock: both builds (each one's per-unit compile times), the checker's unit compiled alone by each tree's flags, main and
# head alternating (three rounds), -c of the frozen sqlite3.c (perf stat, 11 runs a tree a round) with its objects
# compared, and -c over placements (#509's method: six shifts of the checker's unit, three fresh copies, main again as
# the floor, three rounds of time-runs under ab, which takes the lock for each).
echo $$ > ~/buster-fast-bench/claude-784/queue.pid
cd ~/buster-fast-bench/claude-784
out=~/buster-fast-bench/claude-784/out
mkdir -p "$out" ~/buster-fast-bench/claude-784/tmp
lock()
{
    EXCLUSIVE_OWNER=claude-784 EXCLUSIVE_TITLE="IR commands in the backend unit (#784)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/784 ~/buster-fast-bench/exclusive.sh "$@"
}
order()
{
    if [ $(( $1 % 2 )) = 1 ]; then echo main head; else echo head main; fi
}
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
for tree in head main; do
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
cmp "$out/pair-sqlite3-main.o" "$out/pair-sqlite3-head.o" > "$out/pair-object-cmp.log" 2>&1
echo "pair object cmp: $?" >> "$out/progress"
shifts="0 640 1344 2048 2752 3456"
lock bash -c "cd main && BUSTER_DEBUG_INFO=0 ../head/build.sh shifts ../shifts/main main_unit_checker.c $shifts" > "$out/shifts-main.log" 2>&1
echo "shifts main: $?" >> "$out/progress"
lock bash -c "cd head && BUSTER_DEBUG_INFO=0 ./build.sh shifts ../shifts/head main_unit_checker.c $shifts" > "$out/shifts-head.log" 2>&1
echo "shifts head: $?" >> "$out/progress"
builds=()
for b in main:main head:head main-again:main; do
    for s in $shifts; do builds+=(--build "${b%%:*}" "../shifts/${b#*:}/compiler-$s"); done
done
cd head && TMPDIR=$HOME/buster-fast-bench/claude-784/tmp ./build/compiler ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/claude-784/lock.sh ./build/compiler \
    -- time-runs --runs 3 --copies 3 "${builds[@]}" --list $sqlite_options -o $HOME/buster-fast-bench/claude-784/tmp/sqlite3.o > "$out/placements.log" 2>&1
echo "placements: $?" >> "$out/progress"
echo done >> "$out/progress"
