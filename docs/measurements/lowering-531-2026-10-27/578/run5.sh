#!/usr/bin/env bash
# #570's review: lane 0's writer's columns reserved for their room (columns), against main at fe1e928f (main570):
# both built at six placements of the checker's unit, -c of sqlite3.c timed by time-runs under ab, the lock per run.
set -u
cd "$(dirname "$0")"
echo $$ > run5.pid
export EXCLUSIVE_OWNER=claude-531
export EXCLUSIVE_TITLE="#570 review: lane 0's columns' reservation, against main"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/570
lock=$HOME/buster-fast-bench/exclusive.sh
# /tmp is a tmpfs that can run out of inodes; keep this run's temporary files on the home disk.
export TMPDIR=$PWD/tmp
mkdir -p "$TMPDIR"
shifts="0 688 1376 2064 2752 3440"
rm -rf shifts5 out5 && mkdir -p shifts5 out5
for t in main570 columns; do
    "$lock" bash -c "cd $t && BUSTER_DEBUG_INFO=0 ./build.sh shifts ../shifts5/$t main_unit_checker.c $shifts" > "build5-$t.log" 2>&1 || echo "build $t failed"
done
sq=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
opts=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sq" "$sq/sqlite3.c")
for variant in plain g; do
    extra=()
    [ "$variant" = g ] && extra=(-g)
    for t in main570 columns; do
        "$lock" taskset -c 2 "./$t/build/compiler" "${extra[@]}" "${opts[@]}" -o "out5/$t-$variant.o" || echo "compile $t $variant failed"
    done
    cmp "out5/main570-$variant.o" "out5/columns-$variant.o" && echo "object $variant: main570 == columns"
done
builds=()
for b in main:main570 head:columns main-again:main570; do
    for s in $shifts; do builds+=(--build "${b%%:*}" "$PWD/shifts5/${b#*:}/compiler-$s"); done
done
./columns/build/compiler ab --rounds 3 --cpu 2 --lock "$lock" ./columns/build/compiler \
    -- time-runs --runs 3 --copies 3 "${builds[@]}" --list "${opts[@]}" -o /dev/null > ab5.log 2>&1 || echo "ab failed"
echo done
