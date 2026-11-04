#!/usr/bin/env bash
# queue9.sh: after bisect8, ab of the --tier1 -c compile of the frozen sqlite3.c by head-c27be772, head-vscan and
# head-ldscan (commit 7, 8 and 9): 5 rounds of 21 runs, CPU 2, each round one hold of the lock (ab9/).
. ~/buster-fast-bench/claude-141-wide/common.sh
until [ -f bisect8/done ]; do sleep 20; done
mkdir -p ab9
head-ldscan/build/compiler ab --rounds 5 --cpu 2 --lock $lock head-c27be772 head-vscan head-ldscan -- time-runs --runs 21 --list --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/ab9.o $Q/sqlite3.c > ab9/compile-tier1-ab.log 2>&1
echo "exit $?" >> ab9/compile-tier1-ab.log
touch ab9/done
