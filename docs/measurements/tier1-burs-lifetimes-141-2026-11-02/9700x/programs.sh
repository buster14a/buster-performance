#!/usr/bin/env bash
# programs.sh BASE HEAD: on the 9700X, every step one hold of the shared lock, every compile and run pinned to CPU 2;
# outputs in programs-HEAD/.
#  1. Each tree's --tier1-report and --tier1-refusals of the frozen sqlite3.c.
#  2. --tier1 -c of the frozen sqlite3.c: ab of time-runs, 5 rounds of 21 runs, and perf stat, 11 runs a hold, 3 holds.
#  3. speedtest1 built by base's and head's --tier1 and head's Tier 0; a --verify run of each; 11 rounds of the three in
#     a rotating order, each from a fresh database on tmpfs; perf stat of one run each.
. ~/buster-fast-bench/claude-141-takeover/common.sh
base=$1
head=$2
out=$PWD/programs-$head
mkdir -p $out/reports $out/st
for t in $base $head; do
    "$lock" bash -c "cd $RUNDIR && taskset -c 2 $PWD/$t/build/compiler --tier1 --tier1-report --tier1-refusals -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/report-$t.o $Q/sqlite3.c > $out/reports/sqlite3-$t.txt 2>&1"
done
$head/build/compiler ab --rounds 5 --cpu 2 --lock $lock $base $head -- time-runs --runs 21 --list --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/sqlite3-t1.o $Q/sqlite3.c > $out/compile-tier1-ab.log 2>&1
echo "exit $?" >> $out/compile-tier1-ab.log
for r in 1 2 3; do
    for t in $base $head; do
        "$lock" bash -c "taskset -c 2 perf stat -x, -e instructions:u,cycles:u -r 11 -o $out/compile-stat-$t-$r.csv $PWD/$t/build/compiler --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/perf-$t.o $Q/sqlite3.c"
    done
done
st=$out/st
build() { # name command...
    local n=$1
    shift
    "$lock" bash -c "cd $st && taskset -c 2 $* > $st/build-$n.txt 2>&1; echo \"exit \$?\" >> $st/build-$n.txt"
}
build t1base $PWD/$base/build/compiler --tier1 --tier1-report -fno-asynchronous-unwind-tables $FLAGS -I$Q -o st-t1base $SRC/speedtest1-unity.c -lm
build t1 $PWD/$head/build/compiler --tier1 --tier1-report -fno-asynchronous-unwind-tables $FLAGS -I$Q -o st-t1 $SRC/speedtest1-unity.c -lm
build t0 $PWD/$head/build/compiler $FLAGS -I$Q -o st-t0 $SRC/speedtest1-unity.c -lm
builds=(t1base t1 t0)
run() { # build output [speedtest1 options...]
    rm -rf $RUNDIR/run
    mkdir -p $RUNDIR/run/db $RUNDIR/run/tmp
    local s e
    s=$EPOCHREALTIME
    (cd $RUNDIR/run/db && SQLITE_TMPDIR=$RUNDIR/run/tmp taskset -c 2 $st/st-$1 $OPTS "${@:3}" speedtest1.db > $2 2>&1)
    e=$EPOCHREALTIME
    echo "$(( ${e/./} - ${s/./} ))"
}
export -f run
export st RUNDIR OPTS
for c in ${builds[@]}; do
    [ -x $st/st-$c ] && "$lock" bash -c "run $c $st/verify-$c.txt --verify > /dev/null"
done
: > $st/run.times
for r in $(seq 0 10); do
    for i in 0 1 2; do
        c=${builds[$(( (r + i) % 3 ))]}
        [ -x $st/st-$c ] || continue
        o=$st/r$r-$c.txt
        line=$("$lock" bash -c "run $c $o")
        echo "$r $c $line $(awk '/TOTAL/ {print $2}' $o)" >> $st/run.times
    done
done
for c in ${builds[@]}; do
    "$lock" bash -c "rm -rf $RUNDIR/run && mkdir -p $RUNDIR/run/db $RUNDIR/run/tmp && cd $RUNDIR/run/db && SQLITE_TMPDIR=../tmp perf stat -x, -e instructions:u,cycles:u,branches:u,branch-misses:u -o $st/stat-$c.txt -- taskset -c 2 $st/st-$c $OPTS speedtest1.db > /dev/null 2>&1"
done
echo done > $out/done
