#!/usr/bin/env bash
# place10.sh: #509's comparison of commit 7 (head-c27be772) against commit 9 (head-ldscan) over the checker unit's
# placements and fresh copies: each tree linked at six shifts of main_unit_checker.c (its .text is aligned to 64) (shifts/TREE/compiler-SHIFT, each
# build one hold of the lock), then ab of time-runs, 3 rounds, 3 runs, 3 copies, with commit 7 twice (c27be772-again,
# the comparison's floor), on --tier1 -c of the frozen sqlite3.c (place10/).
. ~/buster-fast-bench/claude-141-wide/common.sh
shifts="0 704 1408 2112 2816 3520"
mkdir -p place10 shifts
for t in head-c27be772 head-ldscan; do
    "$lock" bash -c "cd $t && BUSTER_DEBUG_INFO=0 ./build.sh shifts ../shifts/$t main_unit_checker.c $shifts > ../place10/shifts-$t.log 2>&1; echo \"exit \$?\" >> ../place10/shifts-$t.log"
done
builds=()
for b in c27be772:head-c27be772 ldscan:head-ldscan c27be772-again:head-c27be772; do
    for s in $shifts; do builds+=(--build "${b%%:*}" "$PWD/shifts/${b#*:}/compiler-$s"); done
done
head-ldscan/build/compiler ab --rounds 3 --cpu 2 --lock $lock head-ldscan/build/compiler -- time-runs --runs 3 --copies 3 "${builds[@]}" --list --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/place10.o $Q/sqlite3.c > place10/compile-tier1-placements.log 2>&1
echo "exit $?" >> place10/compile-tier1-placements.log
touch place10/done
