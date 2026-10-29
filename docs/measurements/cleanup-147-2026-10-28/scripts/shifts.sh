#!/bin/bash
# #147's cleanup PR against main c9a433b5 over the checker unit's placements and fresh copies (#509's method): -c of the
# frozen sqlite3.c, pinned to CPU 2, ab taking the lock for each time-runs process.
export EXCLUSIVE_OWNER=claude-solve-147 EXCLUSIVE_TITLE="solve 147 (cleanup)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/745"
unset CPATH C_INCLUDE_PATH
B=~/buster-fast-bench
D=$B/solve147-claude
Q=$B/preprocessor-corpora-astra-01a158dd/sqlite
shifts="0 688 1376 2064 2752 3440"
for tree in main head; do
    (cd $D/$tree && BUSTER_DEBUG_INFO=0 $B/exclusive.sh ./build.sh shifts $D/shifts/$tree main_unit_checker.c $shifts > $D/shifts-$tree.log 2>&1) || { echo "shifts $tree failed"; exit 1; }
    echo "shifted $tree"
done
builds=()
for b in main:main head:head main-again:main; do
    for s in $shifts; do builds+=(--build "${b%%:*}" "$D/shifts/${b#*:}/compiler-$s"); done
done
mkdir -p $D/copies
$D/head/build/compiler ab --rounds 3 --cpu 2 --lock $B/exclusive.sh $D/head/build/compiler \
    -- time-runs --runs 3 --copies 3 --directory $D/copies "${builds[@]}" --list -c -I$Q -o $D/shifts-out.o $Q/sqlite3.c > $D/shifts-ab.log 2>&1
echo "ab status $?"
grep -E "^== round|user cycles|instructions|main:|head:|main-again:" $D/shifts-ab.log | grep -v "^  title" | tail -60
echo done
