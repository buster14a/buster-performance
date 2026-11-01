#!/usr/bin/env bash
# queue-2.sh BASE MEASURED HEAD: the final head's build and tests; --tier1 -c of the frozen sqlite3.c and the default
# path's -c, base against head (ab of time-runs, 5 rounds of 21 runs); whether head's code is MEASURED's, byte for byte
# (--tier1 -c's objects of sqlite3.c and speedtest1's --tier1 executables, both paths); and benchmark-tier1-select-source
# on the frozen sqlite3.c (all variants, then each path alone in fresh processes, and the vector path after 200 ms of the
# scalar one), each step one hold of the shared lock, timed runs on CPU 2.
. ~/buster-fast-bench/claude-141-reciprocal/common.sh
base=$1
measured=$2
head=$3
./build.sh "$head"
grep -q "^exit 0" logs-build/$head.log || exit 1
./tests.sh "$head"
logs=$PWD/logs-measure-$head
mkdir -p $logs
$head/build/compiler ab --rounds 5 --cpu 2 --lock $lock $base $head -- time-runs --runs 21 --list --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/sqlite3-t1.o $Q/sqlite3.c > $logs/compile-tier1-ab.log 2>&1
echo "exit $?" >> $logs/compile-tier1-ab.log
$head/build/compiler ab --rounds 5 --cpu 2 --lock $lock $base $head -- time-runs --runs 21 --list -c $FLAGS -I$Q -o $RUNDIR/sqlite3.o $Q/sqlite3.c > $logs/compile-object.log 2>&1
echo "exit $?" >> $logs/compile-object.log
same=$PWD/same-$head
mkdir -p $same
for t in $measured $head; do
    for p in vector scalar; do
        s=$([ $p = scalar ] && echo --scalar)
        "$lock" bash -c "cd $same && taskset -c 2 $PWD/$t/build/compiler --tier1 $s -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o sqlite3-$t-$p.o $Q/sqlite3.c && taskset -c 2 $PWD/$t/build/compiler --tier1 $s -fno-asynchronous-unwind-tables $FLAGS -I$Q -o st-$t-$p $SRC/speedtest1-unity.c -lm"
    done
done
(cd $same && for p in vector scalar; do echo "$p: object $(cmp sqlite3-$measured-$p.o sqlite3-$head-$p.o > /dev/null 2>&1 && echo same || echo differs), executable $(cmp st-$measured-$p st-$head-$p > /dev/null 2>&1 && echo same || echo differs)"; done > result.txt)
sel=$PWD/select-$head
mkdir -p $sel
"$lock" bash -c "taskset -c 2 $head/build/compiler benchmark-tier1-select-source $FLAGS -I$Q $Q/sqlite3.c > $sel/both.txt 2>&1; echo \"exit \$?\" >> $sel/both.txt"
for v in select select-scalar; do
    "$lock" bash -c "taskset -c 2 $head/build/compiler benchmark-tier1-select-source --only $v $FLAGS -I$Q $Q/sqlite3.c > $sel/$v.txt 2>&1; echo \"exit \$?\" >> $sel/$v.txt"
done
"$lock" bash -c "taskset -c 2 $head/build/compiler benchmark-tier1-select-source --only select --after-scalar 200 $FLAGS -I$Q $Q/sqlite3.c > $sel/select-after-scalar.txt 2>&1; echo \"exit \$?\" >> $sel/select-after-scalar.txt"
echo done > queue-2.done
