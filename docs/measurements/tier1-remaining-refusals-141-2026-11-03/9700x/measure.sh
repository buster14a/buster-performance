#!/usr/bin/env bash
# measure.sh BASE HEAD: on the 9700X, every step one hold of the shared lock, every compile and run pinned to CPU 2;
# outputs in measure-HEAD/.
#  1. Each tree's --tier1 --tier1-report --tier1-refusals of the frozen sqlite3.c, and head's with --tier1-strict.
#  2. --tier1 -c of the frozen sqlite3.c: ab of time-runs, 5 rounds of 21 runs, and perf stat, 11 runs a hold, 3 holds.
#  3. perf record of head's --tier1 -c sqlite3.c: the split's (ir_wide_*) share of its cycles.
#  4. speedtest1 built by base's and head's --tier1 and head's Tier 0; a --verify run of each; 11 rounds of the three in
#     a rotating order, each from a fresh database on tmpfs.
#  5. head's test-tier1-wide, natively here.
. ~/buster-fast-bench/claude-141-wide/common.sh
base=$1
head=$2
out=$PWD/measure-$head
mkdir -p $out/reports $out/st
for t in $base $head; do
    "$lock" bash -c "cd $RUNDIR && taskset -c 2 $PWD/$t/build/compiler --tier1 --tier1-report --tier1-refusals -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/report-$t.o $Q/sqlite3.c > $out/reports/sqlite3-$t.txt 2>&1"
done
"$lock" bash -c "cd $RUNDIR && taskset -c 2 $PWD/$head/build/compiler --tier1 --tier1-strict --tier1-report -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/strict-$head.o $Q/sqlite3.c > $out/reports/sqlite3-strict-$head.txt 2>&1; echo \"exit \$?\" >> $out/reports/sqlite3-strict-$head.txt"
$head/build/compiler ab --rounds 5 --cpu 2 --lock $lock $base $head -- time-runs --runs 21 --list --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/sqlite3-t1.o $Q/sqlite3.c > $out/compile-tier1-ab.log 2>&1
echo "exit $?" >> $out/compile-tier1-ab.log
for r in 1 2 3; do
    for t in $base $head; do
        "$lock" bash -c "taskset -c 2 perf stat -x, -e instructions:u,cycles:u -r 11 -o $out/compile-stat-$t-$r.csv $PWD/$t/build/compiler --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/perf-$t.o $Q/sqlite3.c"
    done
done
"$lock" bash -c "cd $RUNDIR && taskset -c 2 perf record -e cycles:u -F 20000 -o $RUNDIR/perf-$head.data $PWD/$head/build/compiler --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/record-$head.o $Q/sqlite3.c > /dev/null 2>&1; perf report -i $RUNDIR/perf-$head.data --stdio --no-children --sort symbol > $out/perf-report-$head.txt 2>&1"
st=$out/st
build() { # name command...
    local n=$1
    shift
    "$lock" bash -c "cd $st && taskset -c 2 $* > $st/build-$n.txt 2>&1; echo \"exit \$?\" >> $st/build-$n.txt"
}
build t1base $PWD/$base/build/compiler --tier1 --tier1-report -fno-asynchronous-unwind-tables $FLAGS -I$Q -o st-t1base $SRC/speedtest1-unity.c -lm
build t1 $PWD/$head/build/compiler --tier1 --tier1-strict --tier1-report -fno-asynchronous-unwind-tables $FLAGS -I$Q -o st-t1 $SRC/speedtest1-unity.c -lm
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
for b in "${builds[@]}"; do
    "$lock" bash -c "run $b $st/verify-$b.txt --verify > /dev/null"
done
for round in $(seq 0 10); do
    for k in 0 1 2; do
        b=${builds[$(( (round + k) % 3 ))]}
        us=$("$lock" bash -c "run $b $st/run-$b-$round.txt")
        echo "$round $b $us" >> $st/times.txt
    done
done
"$lock" bash -c "cd $head && taskset -c 2 ./build/compiler test-tier1-wide > $out/test-tier1-wide.txt 2>&1; echo \"exit \$?\" >> $out/test-tier1-wide.txt"
echo done > $out/done
