#!/bin/bash
# #673 tail growth, integrated tree: the never-grows control (a jobserver with no token) and the no-jobserver one,
# main $2 against head $1 over six placements of the checker's unit and two fresh copies of each, with main's
# placements a second time as the comparison's floor (docs/profiling.md, "Comparing two versions"). Each build and
# time-runs is its own lock hold.
B=~/buster-fast-bench/673-claude
C=~/buster-fast-bench/unclaimed-perf-20261028
H=$1
M=$2
S=$B/shifts-$H
P=$B/shifts-$H.progress
export EXCLUSIVE_OWNER=claude-673 EXCLUSIVE_TITLE="solve 673: never-grows control over placements" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1161
# Multiples of the checker unit's .text alignment, 64, spread over a page.
shifts="0 704 1408 2048 2752 3456"
mkdir -p $S/copies
for T in $M $H; do
    cd $B/$T && BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh ./build.sh shifts $S/$T main_unit_checker.c $shifts > $S/build-$T.log 2>&1
    echo "$(date +%T) shifts $T status=$?" >> $P
    sleep 20
done
builds=""
for b in main:$M head:$H main-again:$M; do
    for s in $shifts; do builds="$builds --build ${b%%:*} $S/${b#*:}/compiler-$s"; done
done
# build.sh shifts can end with status 0 although a shift failed: every placement must be there.
for T in $M $H; do
    for s in $shifts; do
        [ -x $S/$T/compiler-$s ] || { echo "$(date +%T) missing $T compiler-$s" >> $P; echo "$(date +%T) done" >> $P; exit 1; }
    done
done
cd $C
F=$B/jobserver.fifo
[ -p $F ] || mkfifo $F
SQ="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -std=gnu17 --predefines corpus/gnu17-pinned-predefines.txt --clang-features --target=x86_64-linux-gnu -march=znver5 -nostdinc -isystem corpus/headers/usr/lib/clang/23/include -isystem corpus/headers/usr/local/include -isystem corpus/headers/usr/include -Icorpus/sqlite -c corpus/sqlite/sqlite3.c -o $S/timeruns.o"
timeruns() { # name makeflags spare
    ~/buster-fast-bench/exclusive.sh bash -c "exec 3<>$F; head -c $3 /dev/zero >&3; MAKEFLAGS='$2' taskset -c 0-7 $B/$H/build/compiler time-runs --runs 5 --warmups 1 --copies 2 --directory $S/copies $builds --list $SQ; status=\$?; exec 3>&-; exit \$status" > $S/timeruns-$1.log 2>&1
    echo "$(date +%T) timeruns $1 status=$?" >> $P
    sleep 20
}
timeruns empty "-j --jobserver-auth=fifo:$F" 0
timeruns none "" 0
echo "$(date +%T) done" >> $P
