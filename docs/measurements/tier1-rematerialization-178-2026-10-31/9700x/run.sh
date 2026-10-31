#!/usr/bin/env bash
# run.sh TREE: #178's runs on the 9700X for ~/buster-fast-bench/claude-178-remat/TREE (a copy of the session's tree, or
# main's): its build, Tier 1's tests, c-testsuite's subset by --tier1, the corpora's --tier1 -c counts with and without
# rematerialization, and speedtest1 built by Tier 0 and by --tier1 with and without it (both paths), each checked by
# --verify. Each step one hold of the shared lock.
set -u
export LC_ALL=C
cd ~/buster-fast-bench/claude-178-remat || exit 1
name=$1
tree=$PWD/$name
logs=$PWD/logs-$name
st=$PWD/st-$name
mkdir -p "$logs"
export EXCLUSIVE_OWNER=claude-178-remat
export EXCLUSIVE_TITLE="Tier 1 rematerialization in linear scan (#178): builds, tests and measurements"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/178
lock=~/buster-fast-bench/exclusive.sh
corpus=$HOME/buster-fast-bench/preprocessor-corpora-astra-01a158dd
SRC=$HOME/buster-fast-bench/speedtest1-136-claude/src
CTS=$HOME/buster-fast-bench/claude-435/c-testsuite
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
RUNDIR=/tmp/claude-178-st
unset CPATH C_INCLUDE_PATH
mkdir -p $RUNDIR
"$lock" bash -c "cd $tree && BUSTER_DEBUG_INFO=0 ./build.sh > $logs/build.log 2>&1; echo \"exit \$?\" >> $logs/build.log"
tail -1 $logs/build.log
grep -q "^exit 0" $logs/build.log || exit 1
test1() { # name command...
    local n=$1
    shift
    "$lock" bash -c "cd $tree && $* > $logs/$n.log 2>&1; echo \"exit \$?\" >> $logs/$n.log"
    echo "$n $(tail -1 $logs/$n.log): $(tail -2 $logs/$n.log | head -1 | cut -c1-200)"
}
if [ "${SKIP_TESTS:-0}" = 0 ]; then
    test1 select ./build/compiler test-tier1-select
    test1 liveness ./build/compiler test-tier1-liveness
    test1 emit ./build/compiler test-tier1-emit
    test1 pipeline ./build/compiler test-tier1-pipeline --cross-check
    test1 cfg ./build/compiler test-tier1-cfg
    test1 frame-execution ./build/compiler test-tier1-frame-execution
    test1 allocation ./build/compiler test-tier1-allocation
    test1 c-testsuite ./build/compiler test-c-testsuite --tier1 --jobs 8 --subset tests/c-testsuite/subset.txt $CTS
    [ "${DRIVER_TESTS:-1}" = 1 ] && test1 checker-driver ./build/compiler test-checker-driver --executable ./build/compiler
fi
"$lock" bash -c "$PWD/corpus-counts.sh $tree/build/compiler $corpus $CTS $tree/tests/c-testsuite/subset.txt > $logs/counts.txt 2>&1"
cat $logs/counts.txt
"$lock" bash -c "$PWD/corpus-counts.sh $tree/build/compiler $corpus $CTS $tree/tests/c-testsuite/subset.txt --scalar > $logs/counts-scalar.txt 2>&1"
rm -rf $st && mkdir -p $st
build() { # name command...
    local n=$1
    shift
    "$lock" bash -c "cd $st && taskset -c 2 $* > $st/build-$n.txt 2>&1; echo \"exit \$?\" >> $st/build-$n.txt"
}
build t0 $tree/build/compiler $FLAGS -I$corpus/sqlite -o st-t0 $SRC/speedtest1-unity.c -lm
build t1 $tree/build/compiler --tier1 --tier1-report -fno-asynchronous-unwind-tables $FLAGS -I$corpus/sqlite -o st-t1 $SRC/speedtest1-unity.c -lm
build t1s $tree/build/compiler --tier1 --tier1-report --scalar -fno-asynchronous-unwind-tables $FLAGS -I$corpus/sqlite -o st-t1s $SRC/speedtest1-unity.c -lm
if [ "${NO_REMAT:-1}" = 1 ]; then
    build t1n $tree/build/compiler --tier1 --tier1-report --tier1-no-rematerialize -fno-asynchronous-unwind-tables $FLAGS -I$corpus/sqlite -o st-t1n $SRC/speedtest1-unity.c -lm
    build t1ns $tree/build/compiler --tier1 --tier1-report --tier1-no-rematerialize --scalar -fno-asynchronous-unwind-tables $FLAGS -I$corpus/sqlite -o st-t1ns $SRC/speedtest1-unity.c -lm
fi
for b in $st/build-*.txt; do echo "$(basename $b) $(tail -1 $b) $(grep -h '^tier1' $b | tr '\t' '\n' | grep -E '^(tier1|records|spill_stores|spill_loads|call_stores|rematerializations|dropped_definitions|edge_moves|spill_slots|frame_bytes)=' | tr '\n' ' ')"; done
