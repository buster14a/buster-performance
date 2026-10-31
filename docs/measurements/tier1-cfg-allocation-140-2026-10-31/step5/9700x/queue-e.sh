#!/usr/bin/env bash
# queue-e.sh PREVIOUS HEAD: HEAD's build, then speedtest1 by HEAD's --tier1 and --tier1 --scalar against PREVIOUS's
# --tier1 build (st-PREVIOUS/st-t1), HEAD's Tier 0 and clang -O2, a --verify run of each and 11 rounds in a rotating
# order, every step one hold of the shared lock, on CPU 2.
set -u
export LC_ALL=C
cd ~/buster-fast-bench/claude-140-cfg || exit 1
previous=$1
head=$PWD/$2
logs=$PWD/logs-e-$2
mkdir -p "$logs"
export EXCLUSIVE_OWNER=claude-140-cfg
export EXCLUSIVE_TITLE="Tier 1 entry moves #140: speedtest1"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/972
lock=~/buster-fast-bench/exclusive.sh
Q=$HOME/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite
SRC=$HOME/buster-fast-bench/speedtest1-136-claude/src
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
RUNDIR=/tmp/claude-140-st
unset CPATH C_INCLUDE_PATH
mkdir -p $RUNDIR
"$lock" bash -c "cd $head && BUSTER_DEBUG_INFO=0 ./build.sh > $logs/build.log 2>&1; echo \"exit \$?\" >> $logs/build.log"
st=$PWD/st-$2
rm -rf $st && mkdir -p $st
cp $PWD/st-$previous/st-t1 $st/st-t1prev
cp $PWD/st-$previous/st-clang2 $st/st-clang2
build() { # name command...
    local n=$1
    shift
    "$lock" bash -c "cd $st && taskset -c 2 $* > $st/build-$n.txt 2>&1; echo \"exit \$?\" >> $st/build-$n.txt"
}
build t0 $head/build/compiler $FLAGS -I$Q -o st-t0 $SRC/speedtest1-unity.c -lm
build t1 $head/build/compiler --tier1 --tier1-report -fno-asynchronous-unwind-tables $FLAGS -I$Q -o st-t1 $SRC/speedtest1-unity.c -lm
build t1s $head/build/compiler --tier1 --tier1-report --scalar -fno-asynchronous-unwind-tables $FLAGS -I$Q -o st-t1s $SRC/speedtest1-unity.c -lm
builds=(t0 t1 t1s t1prev clang2)
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
for c in t1 t1prev; do
    "$lock" bash -c "rm -rf $RUNDIR/run && mkdir -p $RUNDIR/run/db $RUNDIR/run/tmp && cd $RUNDIR/run/db && SQLITE_TMPDIR=../tmp perf stat -x, -e instructions:u,cycles:u -o $st/stat-$c.txt -- taskset -c 2 $st/st-$c $OPTS speedtest1.db > /dev/null 2>&1"
done
echo done > $logs/done
