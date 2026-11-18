#!/bin/bash
# #2972: counters of the warm tiny.c benchmark by the gate's compiler, vector and twin: STLF interlocks and hits.
D=~/buster-fast-bench/2924-c-df-claude/c8z
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Tier 0 compile counters on tiny functions" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2972
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs/pstat copies
for o in vector scalar; do
    cp compiler-gate copies/run
    $L perf stat -x, -e cycles:u,instructions:u,ls_bad_status2.stli_other:u,ls_stlf:u -o logs/pstat/$o.csv taskset -c 2 ./copies/run benchmark-backend-source --only $o tiny.c > logs/pstat/$o.log 2>&1
    rm -f copies/run
done
cp compiler-gate copies/run
$L perf record -q -e cycles:u -c 20011 -o /dev/shm/claude-c8z.data taskset -c 2 ./copies/run benchmark-backend-source --only vector tiny.c > /dev/null 2>&1
perf annotate -q -i /dev/shm/claude-c8z.data --stdio -s tier0_compile_entries.buster_split 2>/dev/null > logs/pstat/vector-annotate.txt
perf report -q -i /dev/shm/claude-c8z.data --sort symbol --stdio 2>/dev/null | head -40 > logs/pstat/vector-symbols.txt
rm -f /dev/shm/claude-c8z.data copies/run
echo done > logs/pstat/status.txt
