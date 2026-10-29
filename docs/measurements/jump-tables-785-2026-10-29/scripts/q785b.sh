#!/bin/bash
# #785's -c of sqlite3.c over placements (#509's method): main e85d634a and head fa87e1a7, each linked with the
# checker's unit shifted by six amounts over a page, every run from three fresh copies, main a second time as the floor;
# three rounds of time-runs under ab, which takes the lock for each.
echo $$ > ~/buster-fast-bench/claude-785/queue-b.pid
cd ~/buster-fast-bench/claude-785
out=~/buster-fast-bench/claude-785/out
lock()
{
    EXCLUSIVE_OWNER=claude-785 EXCLUSIVE_TITLE="IR: jump tables' successors (#785)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/785 ~/buster-fast-bench/exclusive.sh "$@"
}
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
shifts="0 640 1344 2048 2752 3456"
lock bash -c "cd main && BUSTER_DEBUG_INFO=0 ../head/build.sh shifts ../shifts/main main_unit_checker.c $shifts" > "$out/shifts-main.log" 2>&1
echo "shifts main: $?" >> "$out/progress-b"
lock bash -c "cd head && BUSTER_DEBUG_INFO=0 ./build.sh shifts ../shifts/head main_unit_checker.c $shifts" > "$out/shifts-head.log" 2>&1
echo "shifts head: $?" >> "$out/progress-b"
builds=()
for b in main:main head:head main-again:main; do
    for s in $shifts; do builds+=(--build "${b%%:*}" "../shifts/${b#*:}/compiler-$s"); done
done
mkdir -p ~/buster-fast-bench/claude-785/tmp
cd head && TMPDIR=$HOME/buster-fast-bench/claude-785/tmp ./build/compiler ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/claude-785/lock.sh ./build/compiler \
    -- time-runs --runs 3 --copies 3 "${builds[@]}" --list -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$corpus/sqlite $corpus/sqlite/sqlite3.c -o $HOME/buster-fast-bench/claude-785/tmp/sqlite3.o > "$out/placements.log" 2>&1
echo "placements: $?" >> "$out/progress-b"
echo done >> "$out/progress-b"
