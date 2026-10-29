#!/bin/bash
# The comparison over placements (#509): main, the PR1 head and the PR3 head, each linked at four placements of the
# checker unit (build.sh shifts), then -c sqlite3.c timed by time-runs over every placement and three fresh copies of
# each, with main again as the comparison floor; three rounds under ab, each time-runs process under the lock alone, on
# CPU 2.
set -e
cd ~/buster-fast-bench/cc137-claude
export EXCLUSIVE_OWNER=claude-137 EXCLUSIVE_TITLE="solve #137 (A/B over code placements)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/137
D=~/buster-fast-bench/cc137-claude
shifts="0 1024 2048 3072"
rm -rf $D/shifts && mkdir -p $D/shifts
for t in main head pr3; do
    (cd $t && BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh shifts $D/shifts/$t main_unit_checker.c $shifts > shifts.log 2>&1 && tail -2 shifts.log)
done
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
O=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$S" "$S/sqlite3.c")
builds=()
for b in main:main head:head pr3:pr3 main-again:main; do
    for s in $shifts; do builds+=(--build "${b%%:*}" "$D/shifts/${b#*:}/compiler-$s"); done
done
mkdir -p $D/copies
./main/build/compiler ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh ./main/build/compiler \
    -- time-runs --runs 3 --copies 3 --directory $D/copies "${builds[@]}" --list -c "${O[@]}" -o /tmp/cc137-shift.o > shifts-ab.log 2>&1
echo "shifts: $?"
echo done
