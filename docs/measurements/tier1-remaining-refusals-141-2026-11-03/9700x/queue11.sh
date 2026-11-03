#!/usr/bin/env bash
# queue11.sh: commit 11 (9a26fd50, the revert) against commit 12 (3a2ce1b5, the scans by the requested path, with the
# per-thread count of vector-path scans): each tree's build (its CMake build.sh, BUSTER_DEBUG_INFO=0), then perf stat of
# --tier1 -c of the frozen sqlite3.c (bisect.sh, bisect11/) and ab of 5 rounds of 21 runs (ab11/).
. ~/buster-fast-bench/claude-141-wide/common.sh
for t in head-9a26fd50 head-3a2ce1b5; do
    rm -rf $t && tar xzf $t.tgz && rm $t.tgz
done
./build.sh head-9a26fd50 head-3a2ce1b5
BISECT_OUT=bisect11 ./bisect.sh head-9a26fd50 head-3a2ce1b5
mkdir -p ab11
head-3a2ce1b5/build/compiler ab --rounds 5 --cpu 2 --lock $lock head-9a26fd50 head-3a2ce1b5 -- time-runs --runs 21 --list --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/ab11.o $Q/sqlite3.c > ab11/compile-tier1-ab.log 2>&1
echo "exit $?" >> ab11/compile-tier1-ab.log
touch ab11/done
