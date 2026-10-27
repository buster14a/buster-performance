#!/usr/bin/env bash
# #578 review: lane 0 columns measured on an arena of no memory (head578, 52e90957), against main at 8e1fbb2b (main8e1):
# both built at six placements of the checker unit, -c of sqlite3.c timed by time-runs under ab, the lock per run.
set -u
cd "$(dirname "$0")"
echo $$ > run6.pid
export EXCLUSIVE_OWNER=claude-531
export EXCLUSIVE_TITLE="#578 review: lane 0 columns measured on no memory, against main"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/578
lock=$HOME/buster-fast-bench/exclusive.sh
# /tmp is a tmpfs that can run out of inodes; keep this run's temporary files on the home disk.
export TMPDIR=$PWD/tmp
mkdir -p "$TMPDIR"
shifts="0 688 1376 2064 2752 3440"
rm -rf shifts6 out6 && mkdir -p shifts6 out6
for t in main8e1 head578; do
    "$lock" bash -c "cd $t && BUSTER_DEBUG_INFO=0 ./build.sh shifts ../shifts6/$t main_unit_checker.c $shifts" > "build6-$t.log" 2>&1 || echo "build $t failed"
done
sq=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
opts=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sq" "$sq/sqlite3.c")
for variant in plain g; do
    extra=()
    [ "$variant" = g ] && extra=(-g)
    for t in main8e1 head578; do
        "$lock" taskset -c 2 "./$t/build/compiler" "${extra[@]}" "${opts[@]}" -o "out6/$t-$variant.o" || echo "compile $t $variant failed"
    done
    cmp "out6/main8e1-$variant.o" "out6/head578-$variant.o" && echo "object $variant: main8e1 == head578"
done
builds=()
for b in main:main8e1 head:head578 main-again:main8e1; do
    for s in $shifts; do builds+=(--build "${b%%:*}" "$PWD/shifts6/${b#*:}/compiler-$s"); done
done
./head578/build/compiler ab --rounds 3 --cpu 2 --lock "$lock" ./head578/build/compiler \
    -- time-runs --runs 3 --copies 3 "${builds[@]}" --list "${opts[@]}" -o /dev/null > ab6.log 2>&1 || echo "ab failed"
echo done
