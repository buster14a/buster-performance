#!/usr/bin/env bash
# dev.sh NAME [PREVIOUS]: build ~/buster-fast-bench/claude-140-cfg/dev-NAME (a copy of the laptop's tree), run Tier 1's
# tests, c-testsuite's subset by --tier1, speedtest1 built by --tier1 (both paths) and checked by --verify, and with
# PREVIOUS (a tree whose st-dev-PREVIOUS has its builds) 11 rounds of speedtest1 against its --tier1 build and Tier 0's,
# each step one hold of the shared lock, timed runs on CPU 2.
set -u
export LC_ALL=C
cd ~/buster-fast-bench/claude-140-cfg || exit 1
name=$1
previous=${2:-}
tree=$PWD/dev-$name
logs=$PWD/logs-dev-$name
st=$PWD/st-dev-$name
mkdir -p "$logs"
export EXCLUSIVE_OWNER=claude-140-cfg
export EXCLUSIVE_TITLE="Tier 1 selection (#141, #989 review hardening): build and tests"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/989
lock=~/buster-fast-bench/exclusive.sh
Q=$HOME/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite
SRC=$HOME/buster-fast-bench/speedtest1-136-claude/src
CTS=$HOME/buster-fast-bench/claude-435/c-testsuite
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
RUNDIR=/tmp/claude-140-st
unset CPATH C_INCLUDE_PATH
mkdir -p $RUNDIR
"$lock" bash -c "cd $tree && BUSTER_DEBUG_INFO=0 ./build.sh > $logs/build.log 2>&1; echo \"exit \$?\" >> $logs/build.log"
tail -1 $logs/build.log
grep -q "^exit 0" $logs/build.log || exit 1
test1() { # name command...
    local n=$1
    shift
    "$lock" bash -c "cd $tree && $* > $logs/$n.log 2>&1; echo \"exit \$?\" >> $logs/$n.log"
    echo "$n $(tail -1 $logs/$n.log): $(tail -2 $logs/$n.log | head -1 | cut -c1-150)"
}
test1 select ./build/compiler test-tier1-select
test1 liveness ./build/compiler test-tier1-liveness
test1 emit ./build/compiler test-tier1-emit
test1 pipeline ./build/compiler test-tier1-pipeline --cross-check
test1 cfg ./build/compiler test-tier1-cfg
test1 frame-execution ./build/compiler test-tier1-frame-execution
test1 model ./build/compiler test-tier1-model
test1 schedule ./build/compiler test-tier1-schedule
test1 allocation ./build/compiler test-tier1-allocation
test1 c-testsuite ./build/compiler test-c-testsuite --tier1 --jobs 8 --subset tests/c-testsuite/subset.txt $CTS
rm -rf $st && mkdir -p $st
build() { # name command...
    local n=$1
    shift
    "$lock" bash -c "cd $st && taskset -c 2 $* > $st/build-$n.txt 2>&1; echo \"exit \$?\" >> $st/build-$n.txt"
}
build t0 $tree/build/compiler $FLAGS -I$Q -o st-t0 $SRC/speedtest1-unity.c -lm
build t1 $tree/build/compiler --tier1 --tier1-report -fno-asynchronous-unwind-tables $FLAGS -I$Q -o st-t1 $SRC/speedtest1-unity.c -lm
build t1s $tree/build/compiler --tier1 --tier1-report --scalar -fno-asynchronous-unwind-tables $FLAGS -I$Q -o st-t1s $SRC/speedtest1-unity.c -lm
grep -h "^tier1" $st/build-t1.txt | tr '\t' '\n' | grep -E "^(functions|tier1|records|spill_stores|spill_loads|call_stores|edge_moves)=" | tr '\n' ' '; echo
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
builds=(t0 t1 t1s)
if [ -n "$previous" ]; then
    cp $PWD/st-dev-$previous/st-t1 $st/st-t1prev
    builds+=(t1prev)
fi
for c in ${builds[@]}; do
    "$lock" bash -c "run $c $st/verify-$c.txt --verify > /dev/null"
    echo "$c $(grep -h "Verification Hash" $st/verify-$c.txt)"
done
[ -n "$previous" ] || exit 0
: > $st/run.times
for r in $(seq 0 10); do
    for i in $(seq 0 $(( ${#builds[@]} - 1 ))); do
        c=${builds[$(( (r + i) % ${#builds[@]} ))]}
        o=$st/r$r-$c.txt
        line=$("$lock" bash -c "run $c $o")
        echo "$r $c $line" >> $st/run.times
    done
done
for c in ${builds[@]}; do
    awk -v c=$c '$2 == c {print $3}' $st/run.times | sort -n | awk -v c=$c '{a[NR]=$1} END {printf "%s median %d us (%d-%d)\n", c, a[int((NR+1)/2)], a[1], a[NR]}'
done
for c in t1 t1prev; do
    "$lock" bash -c "rm -rf $RUNDIR/run && mkdir -p $RUNDIR/run/db $RUNDIR/run/tmp && cd $RUNDIR/run/db && SQLITE_TMPDIR=../tmp perf stat -x, -e instructions:u,cycles:u -o $st/stat-$c.txt -- taskset -c 2 $st/st-$c $OPTS speedtest1.db > /dev/null 2>&1"
    echo "$c: $(grep -v '^#' $st/stat-$c.txt | cut -d, -f1,3 | tr '\n' ' ')"
done
