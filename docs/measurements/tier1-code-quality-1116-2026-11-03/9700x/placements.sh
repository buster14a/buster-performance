#!/usr/bin/env bash
# placements.sh: ab of time-runs over the trees' six placements of main_unit_backend.c each (shifts.sh), main 703ae9f5,
# the pull request at 8b07e868, the change at 3b195d57, and main again as the comparison's floor; --tier1 -c of the
# frozen sqlite3.c, 2 runs of 2 fresh copies of every executable per round, 3 rounds, each round one hold (ab takes the
# lock), CPU 2. Output in placements/.
. ~/buster-fast-bench/1116-claude/common.sh
shifts="0 640 1344 2048 2752 3456"
builds=()
for b in main:p-703ae9f5 pr:p-8b07e868 new:p-3b195d57 main-again:p-703ae9f5; do
    for s in $shifts; do builds+=(--build "${b%%:*}" "$PWD/shifts/${b#*:}/compiler-$s"); done
done
out=$PWD/placements
mkdir -p $out
p-3b195d57/build/compiler ab --rounds 3 --cpu 2 --lock $lock $PWD/p-3b195d57/build/compiler -- time-runs --runs 2 --copies 2 "${builds[@]}" --list --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/placement.o $Q/sqlite3.c > $out/ab.log 2>&1
echo "exit $?" >> $out/ab.log
