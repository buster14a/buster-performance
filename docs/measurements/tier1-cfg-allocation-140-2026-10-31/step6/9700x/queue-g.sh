#!/usr/bin/env bash
# queue-g.sh BASE HEAD: the selection walks' 9700X measurements (#140, #141's items), every step one hold of the shared lock, timed runs on CPU 2.
#  1. both trees' builds (BUSTER_DEBUG_INFO=0), with build.sh's unit times;
#  2. the default path on the frozen sqlite3.c, base against head: ab of time-runs, 5 rounds of 21 runs of -c and of
#     the direct path's link; then head's -c with and without --tier1, 5 rounds of 21;
#  3. speedtest1 (#136's harness: the frozen sqlite3.c, SQLite 3.53.2's speedtest1.c, its flags and options) built by
#     head's Tier 0, --tier1, --tier1 --scalar, base's Tier 0 and --tier1, clang -O0 and clang -O2; a --verify run of each; then
#     11 rounds of the builds in a rotating order, each from a fresh database on tmpfs;
#  4. perf record of head's Tier 0 and --tier1 builds' runs, for where their cycles go.
set -u
export LC_ALL=C
cd ~/buster-fast-bench/claude-140-cfg || exit 1
base=$1
head=$2
logs=$PWD/logs-g-$head
# The trees' compilers by absolute paths: the speedtest1 builds run in their own directory.
basedir=$PWD/$base
headdir=$PWD/$head
mkdir -p "$logs"
export EXCLUSIVE_OWNER=claude-140-cfg
export EXCLUSIVE_TITLE="Tier 1 selection walks #140: measurements"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/140
lock=~/buster-fast-bench/exclusive.sh
Q=$HOME/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite
SRC=$HOME/buster-fast-bench/speedtest1-136-claude/src
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
RUNDIR=/tmp/claude-140-st
unset CPATH C_INCLUDE_PATH
for t in $base $head; do
    "$lock" bash -c "cd $t && BUSTER_DEBUG_INFO=0 ./build.sh > $logs/build-$t.log 2>&1; echo \"exit \$?\" >> $logs/build-$t.log"
done
mkdir -p $RUNDIR
for list in "-c $FLAGS -I$Q -o $RUNDIR/sqlite3.o $Q/sqlite3.c" "$FLAGS -I$Q -o $RUNDIR/sqlite3.exe $SRC/speedtest1-unity.c -lm"; do
    name=$([ "${list#-c }" != "$list" ] && echo object || echo link)
    $head/build/compiler ab --rounds 5 --cpu 2 --lock $lock $base $head -- time-runs --runs 21 --list $list > $logs/compile-$name.log 2>&1
    echo "exit $?" >> $logs/compile-$name.log
done
$head/build/compiler ab --rounds 5 --cpu 2 --lock $lock $head -- time-runs --runs 21 --list -c $FLAGS -I$Q -o $RUNDIR/sqlite3.o $Q/sqlite3.c \
    --list --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $RUNDIR/sqlite3-tier1.o $Q/sqlite3.c > $logs/compile-tier1.log 2>&1
echo "exit $?" >> $logs/compile-tier1.log
st=$PWD/st-g-$head
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
for c in t0 t1 t1base; do
    "$lock" bash -c "rm -rf $RUNDIR/run && mkdir -p $RUNDIR/run/db $RUNDIR/run/tmp && cd $RUNDIR/run/db && SQLITE_TMPDIR=$RUNDIR/run/tmp perf record -q -e cycles:u -c 200003 -o $st/perf-$c.data -- taskset -c 2 $st/st-$c $OPTS speedtest1.db > $st/perf-$c.txt 2>&1"
done
echo done > $logs/done
