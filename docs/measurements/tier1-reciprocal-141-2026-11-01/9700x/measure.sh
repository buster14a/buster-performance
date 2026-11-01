#!/usr/bin/env bash
# measure.sh BASE HEAD: #141's reciprocal division against main, on the 9700X, every step one hold of the shared lock,
# timed runs on CPU 2 (step 6's queue-g.sh, queue-h.sh and queue-i.sh, buster-performance#183, with these trees):
#  1. the default path on the frozen sqlite3.c, base against head: ab of time-runs, 5 rounds of 21 runs of -c and of
#     the direct path's link of speedtest1;
#  2. --tier1 -c of the frozen sqlite3.c, base against head, the same way, and each tree's --tier1-report of it;
#  3. speedtest1 (#136's harness: the frozen sqlite3.c, SQLite 3.53.2's speedtest1.c, its flags and options) built by
#     head's Tier 0, --tier1 and --tier1 --scalar, base's Tier 0 and --tier1, clang -O0 and clang -O2; a --verify run of
#     each; 11 rounds of the seven in a rotating order, each from a fresh database on tmpfs; perf stat of one run each;
#     perf record of head's Tier 0 and --tier1 builds' runs and base's --tier1 build's.
. ~/buster-fast-bench/claude-141-reciprocal/common.sh
base=$1
head=$2
logs=$PWD/logs-measure-$head
st=$PWD/st-$head
basedir=$PWD/$base
headdir=$PWD/$head
mkdir -p $logs
for list in "-c $FLAGS -I$Q -o $RUNDIR/sqlite3.o $Q/sqlite3.c" "$FLAGS -I$Q -o $RUNDIR/sqlite3.exe $SRC/speedtest1-unity.c -lm"; do
    name=$([ "${list#-c }" != "$list" ] && echo object || echo link)
    $head/build/compiler ab --rounds 5 --cpu 2 --lock $lock $base $head -- time-runs --runs 21 --list $list > $logs/compile-$name.log 2>&1
    echo "exit $?" >> $logs/compile-$name.log
done
$head/build/compiler ab --rounds 5 --cpu 2 --lock $lock $base $head -- time-runs --runs 21 --list --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/sqlite3-t1.o $Q/sqlite3.c > $logs/compile-tier1-ab.log 2>&1
echo "exit $?" >> $logs/compile-tier1-ab.log
for t in $base $head; do
    "$lock" bash -c "cd $RUNDIR && taskset -c 2 $PWD/$t/build/compiler --tier1 --tier1-report -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/sqlite3-t1-$t.o $Q/sqlite3.c > $logs/report-sqlite3-$t.txt 2>&1"
done
rm -rf $st && mkdir -p $st
build() { # name command...
    local n=$1
    shift
    "$lock" bash -c "cd $st && taskset -c 2 $* > $st/build-$n.txt 2>&1; echo \"exit \$?\" >> $st/build-$n.txt"
}
build t0 $headdir/build/compiler $FLAGS -I$Q -o st-t0 $SRC/speedtest1-unity.c -lm
build t1 $headdir/build/compiler --tier1 --tier1-report -fno-asynchronous-unwind-tables $FLAGS -I$Q -o st-t1 $SRC/speedtest1-unity.c -lm
build t1s $headdir/build/compiler --tier1 --tier1-report --scalar -fno-asynchronous-unwind-tables $FLAGS -I$Q -o st-t1s $SRC/speedtest1-unity.c -lm
build t0base $basedir/build/compiler $FLAGS -I$Q -o st-t0base $SRC/speedtest1-unity.c -lm
build t1base $basedir/build/compiler --tier1 --tier1-report -fno-asynchronous-unwind-tables $FLAGS -I$Q -o st-t1base $SRC/speedtest1-unity.c -lm
build clang0 "clang -O0 -c $FLAGS -I$Q -o clang0-sqlite3.o $Q/sqlite3.c && clang -O0 -c $FLAGS -I$Q -o clang0-speedtest1.o $SRC/speedtest1.c && cc -o st-clang0 clang0-speedtest1.o clang0-sqlite3.o -lm"
build clang2 "clang -O2 -c $FLAGS -I$Q -o clang2-sqlite3.o $Q/sqlite3.c && clang -O2 -c $FLAGS -I$Q -o clang2-speedtest1.o $SRC/speedtest1.c && cc -o st-clang2 clang2-speedtest1.o clang2-sqlite3.o -lm"
builds=(t0 t1 t1s t0base t1base clang0 clang2)
run() { # build output [speedtest1 options...]
    rm -rf $RUNDIR/run
    mkdir -p $RUNDIR/run/db $RUNDIR/run/tmp
    local s e
    TIMEFORMAT='%3U %3S'
    s=$EPOCHREALTIME
    { time (cd $RUNDIR/run/db && SQLITE_TMPDIR=$RUNDIR/run/tmp taskset -c 2 $st/st-$1 $OPTS "${@:3}" speedtest1.db > $2 2>&1) ; } 2> $2.time
    e=$EPOCHREALTIME
    echo "$(( ${e/./} - ${s/./} )) $(cat $2.time)"
}
export -f run
export st RUNDIR OPTS
for c in ${builds[@]}; do
    [ -x $st/st-$c ] && "$lock" bash -c "run $c $st/verify-$c.txt --verify > /dev/null"
done
: > $st/run.times
for r in $(seq 0 10); do
    for i in $(seq 0 $(( ${#builds[@]} - 1 ))); do
        c=${builds[$(( (r + i) % ${#builds[@]} ))]}
        [ -x $st/st-$c ] || continue
        o=$st/r$r-$c.txt
        line=$("$lock" bash -c "run $c $o")
        echo "$r $c $line $(awk '/TOTAL/ {print $2}' $o)" >> $st/run.times
    done
done
for c in t0 t1 t1s t1base clang2; do
    "$lock" bash -c "rm -rf $RUNDIR/run && mkdir -p $RUNDIR/run/db $RUNDIR/run/tmp && cd $RUNDIR/run/db && SQLITE_TMPDIR=../tmp perf stat -x, -e instructions:u,cycles:u,branches:u,branch-misses:u -o $st/stat-$c.txt -- taskset -c 2 $st/st-$c $OPTS speedtest1.db > /dev/null 2>&1"
done
for c in t0 t1 t1base; do
    "$lock" bash -c "rm -rf $RUNDIR/run && mkdir -p $RUNDIR/run/db $RUNDIR/run/tmp && cd $RUNDIR/run/db && SQLITE_TMPDIR=$RUNDIR/run/tmp perf record -q -e cycles:u -c 200003 -o $st/perf-$c.data -- taskset -c 2 $st/st-$c $OPTS speedtest1.db > $st/perf-$c.txt 2>&1"
done
echo done > $logs/done
