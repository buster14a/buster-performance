#!/usr/bin/env bash
# placements.sh BASE HEAD [UNIT [SHIFTS]]: --tier1 -c of the frozen sqlite3.c, base against head over six placements of
# UNIT (main_unit_backend.c by default; main_unit_checker.c holds the driver that runs --tier1), three fresh copies each,
# main against itself as the floor (docs/profiling.md, "Builds over their code's placements and copies"): both trees'
# shifted builds (head's build.sh, BUSTER_DEBUG_INFO=0), each one hold of the shared lock, then ab of time-runs, 3
# rounds of 3 runs, each round one hold, pinned to CPU 2.
. ~/buster-fast-bench/claude-141-remaining/common.sh
base=$1
head=$2
unit=${3:-main_unit_backend.c}
shifts=${4:-"0 640 1344 2048 2752 3456"}
out=$PWD/placements-$head-${unit%.c}
mkdir -p $out
for t in $base $head; do
    "$lock" bash -c "cd $t && BUSTER_DEBUG_INFO=0 ../$head/build.sh shifts $out/$t $unit $shifts > $out/build-$t.log 2>&1; echo \"exit \$?\" >> $out/build-$t.log"
    grep -q "^exit 0" $out/build-$t.log || exit 1
done
builds=()
for b in main:$base head:$head main-again:$base; do
    for s in $shifts; do builds+=(--build "${b%%:*}" "$out/${b#*:}/compiler-$s"); done
done
$head/build/compiler ab --rounds 3 --cpu 2 --lock $lock $head/build/compiler -- time-runs --runs 3 --copies 3 "${builds[@]}" --list --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/placements.o $Q/sqlite3.c > $out/tier1.log 2>&1
echo "exit $?" >> $out/tier1.log
echo done > $out/done
