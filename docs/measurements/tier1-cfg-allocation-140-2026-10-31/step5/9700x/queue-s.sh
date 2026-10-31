#!/usr/bin/env bash
# queue-s.sh BASE HEAD: queue-c.sh's speedtest1 part alone (step 3 and 4), every step one hold of the shared lock, timed
# runs on CPU 2, the trees' compilers by absolute paths.
set -u
export LC_ALL=C
cd ~/buster-fast-bench/claude-140-cfg || exit 1
base=$PWD/$1
head=$PWD/$2
logs=$PWD/logs-c-$2
mkdir -p "$logs"
export EXCLUSIVE_OWNER=claude-140-cfg
export EXCLUSIVE_TITLE="Tier 1 --tier1 #140: speedtest1"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/970
lock=~/buster-fast-bench/exclusive.sh
Q=$HOME/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite
SRC=$HOME/buster-fast-bench/speedtest1-136-claude/src
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
RUNDIR=/tmp/claude-140-st
unset CPATH C_INCLUDE_PATH
mkdir -p $RUNDIR
st=$PWD/st-$2
rm -rf $st && mkdir -p $st
build() { # name command...
    local n=$1
    shift
    "$lock" bash -c "cd $st && taskset -c 2 $* > $st/build-$n.txt 2>&1; echo \"exit \$?\" >> $st/build-$n.txt"
}
build t0 $head/build/compiler $FLAGS -I$Q -o st-t0 $SRC/speedtest1-unity.c -lm
build t1 $head/build/compiler --tier1 --tier1-report -fno-asynchronous-unwind-tables $FLAGS -I$Q -o st-t1 $SRC/speedtest1-unity.c -lm
build t1s $head/build/compiler --tier1 --tier1-report --scalar -fno-asynchronous-unwind-tables $FLAGS -I$Q -o st-t1s $SRC/speedtest1-unity.c -lm
build t0base $base/build/compiler $FLAGS -I$Q -o st-t0base $SRC/speedtest1-unity.c -lm
build clang0 "clang -O0 -c $FLAGS -I$Q -o clang0-sqlite3.o $Q/sqlite3.c && clang -O0 -c $FLAGS -I$Q -o clang0-speedtest1.o $SRC/speedtest1.c && cc -o st-clang0 clang0-speedtest1.o clang0-sqlite3.o -lm"
build clang2 "clang -O2 -c $FLAGS -I$Q -o clang2-sqlite3.o $Q/sqlite3.c && clang -O2 -c $FLAGS -I$Q -o clang2-speedtest1.o $SRC/speedtest1.c && cc -o st-clang2 clang2-speedtest1.o clang2-sqlite3.o -lm"
builds=(t0 t1 t1s t0base clang0 clang2)
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
for c in t0 t1; do
    "$lock" bash -c "rm -rf $RUNDIR/run && mkdir -p $RUNDIR/run/db $RUNDIR/run/tmp && cd $RUNDIR/run/db && SQLITE_TMPDIR=$RUNDIR/run/tmp perf record -q -e cycles:u -c 200003 -o $st/perf-$c.data -- taskset -c 2 $st/st-$c $OPTS speedtest1.db > $st/perf-$c.txt 2>&1"
done
echo done > $logs/speedtest1-done
