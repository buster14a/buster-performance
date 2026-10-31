#!/usr/bin/env bash
# queue-i.sh BASE HEAD: --tier1 -c of the frozen sqlite3.c, base against head: ab of time-runs, 5 rounds of 21 runs, each
# run one hold of the shared lock, on CPU 2 (both trees built by queue-g.sh).
set -u
export LC_ALL=C
cd ~/buster-fast-bench/claude-140-cfg || exit 1
base=$1
head=$2
logs=$PWD/logs-g-$head
export EXCLUSIVE_OWNER=claude-140-cfg
export EXCLUSIVE_TITLE="Tier 1 selection walks #140: --tier1 compile time"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/140
lock=~/buster-fast-bench/exclusive.sh
Q=$HOME/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
RUNDIR=/tmp/claude-140-st
unset CPATH C_INCLUDE_PATH
mkdir -p $RUNDIR
$head/build/compiler ab --rounds 5 --cpu 2 --lock $lock $base $head -- time-runs --runs 21 --list --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/sqlite3-t1.o $Q/sqlite3.c > $logs/compile-tier1-ab.log 2>&1
echo "exit $?" >> $logs/compile-tier1-ab.log
for t in $base $head; do
    "$lock" bash -c "cd $RUNDIR && taskset -c 2 $PWD/$t/build/compiler --tier1 --tier1-report -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/sqlite3-t1-$t.o $Q/sqlite3.c > $logs/report-sqlite3-$t.txt 2>&1"
done
echo done >> $logs/compile-tier1-ab.log
