#!/usr/bin/env bash
# queue-l.sh BASE HEAD: #989's review's test hardening, measured against #989's previous head: HEAD's build
# (BUSTER_DEBUG_INFO=0), then both compilers' outputs compared byte for byte (-c and --tier1 -c of the frozen
# sqlite3.c, and speedtest1's Tier 0, --tier1 and --tier1 --scalar executables), then --tier1 -c of sqlite3.c, base
# against head: ab of time-runs, 5 rounds of 21 runs. Each step one hold of the shared lock, on CPU 2.
set -u
export LC_ALL=C
cd ~/buster-fast-bench/claude-140-cfg || exit 1
base=$1
head=$2
logs=$PWD/logs-l-$head
mkdir -p "$logs"
export EXCLUSIVE_OWNER=claude-140-cfg
export EXCLUSIVE_TITLE="Tier 1 #141: #989 review's test hardening, measured"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/989
lock=~/buster-fast-bench/exclusive.sh
Q=$HOME/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite
SRC=$HOME/buster-fast-bench/speedtest1-136-claude/src
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
RUNDIR=/tmp/claude-140-st
unset CPATH C_INCLUDE_PATH
mkdir -p $RUNDIR
"$lock" bash -c "cd $head && BUSTER_DEBUG_INFO=0 ./build.sh > $logs/build-$head.log 2>&1; echo \"exit \$?\" >> $logs/build-$head.log"
tail -1 $logs/build-$head.log
grep -q "^exit 0" $logs/build-$head.log || exit 1
out=$logs/outputs
mkdir -p $out
for t in $base $head; do
    c=$PWD/$t/build/compiler
    "$lock" bash -c "cd $out && taskset -c 2 $c -c $FLAGS -I$Q -o sqlite3-t0-$t.o $Q/sqlite3.c && taskset -c 2 $c --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o sqlite3-t1-$t.o $Q/sqlite3.c && taskset -c 2 $c $FLAGS -I$Q -o st-t0-$t $SRC/speedtest1-unity.c -lm && taskset -c 2 $c --tier1 -fno-asynchronous-unwind-tables $FLAGS -I$Q -o st-t1-$t $SRC/speedtest1-unity.c -lm && taskset -c 2 $c --tier1 --scalar -fno-asynchronous-unwind-tables $FLAGS -I$Q -o st-t1s-$t $SRC/speedtest1-unity.c -lm" > $logs/outputs-$t.log 2>&1
    echo "outputs $t: exit $?"
done
for o in sqlite3-t0 sqlite3-t1 st-t0 st-t1 st-t1s; do
    if cmp -s $out/$o-$base* $out/$o-$head*; then
        echo "$o: identical, $(stat -c %s $out/$o-$head*) bytes, sha256 $(sha256sum $out/$o-$head* | cut -c1-16)"
    else
        echo "$o: DIFFERENT"
    fi
done | tee $logs/identity.txt
$PWD/$head/build/compiler ab --rounds 5 --cpu 2 --lock $lock $base $head -- time-runs --runs 21 --list --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/sqlite3-t1.o $Q/sqlite3.c > $logs/compile-tier1-ab.log 2>&1
echo "exit $?" >> $logs/compile-tier1-ab.log
tail -12 $logs/compile-tier1-ab.log
echo done
