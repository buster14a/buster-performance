#!/bin/bash
# #2972: Tier 0's compile on tiny functions (tiny.c: 1,000 empty functions and 1,000 of one add), warm, by the vector
# path and its twin (benchmark-backend-source, head of #2975), then the vector path's cycles by symbol. Under the lock, CPU 2.
cd ~/buster-fast-bench/2924-c-df-claude/c8a || exit 1
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Tier 0 compile on tiny functions" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2972
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs/tiny
for o in vector scalar validate validate-scalar; do
    cp compilers/head copies/head-run
    $L taskset -c 2 ./copies/head-run benchmark-backend-source --only $o tiny.c > logs/tiny/$o.log 2>&1
    rm -f copies/head-run
done
$L perf record -q -e cycles:u -c 20011 -o /dev/shm/claude-tiny.data taskset -c 2 compilers/head benchmark-backend-source --only vector tiny.c > /dev/null 2>&1
perf report -q -i /dev/shm/claude-tiny.data --sort symbol --stdio 2>/dev/null | head -45 > logs/tiny/vector-symbols.txt
$L perf record -q -e cycles:u -c 20011 -o /dev/shm/claude-tiny.data taskset -c 2 compilers/head benchmark-backend-source --only scalar tiny.c > /dev/null 2>&1
perf report -q -i /dev/shm/claude-tiny.data --sort symbol --stdio 2>/dev/null | head -45 > logs/tiny/scalar-symbols.txt
rm -f /dev/shm/claude-tiny.data
for o in vector scalar validate validate-scalar; do grep -A1 "^variant" logs/tiny/$o.log | tail -1; done
