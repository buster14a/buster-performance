#!/bin/bash
# #2972: Tier 0's compile stages by entry count on tiny functions. src: #2975's head + fixes + finer marks;
# src-nofix: the finer marks alone. Under the lock, CPU 2.
D=~/buster-fast-bench/2924-c-df-claude/c8y
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Tier 0 compile stages on tiny functions" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2972
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs2 copies
for t in fix nofix; do
    s=src; [ $t = nofix ] && s=src-nofix
    (cd $s && $L timeout -k 5 1800 ./build.sh --config Release > "$D/logs2/build-$t.log" 2>&1) || { echo "build $t failed" > logs2/status.txt; exit 1; }
    cp $s/build/compiler compiler-$t
done
for round in 1 2 3; do
    for t in fix nofix; do
        for o in vector scalar; do
            cp compiler-$t copies/run
            BUSTER_TIER0_STAGES="$D/logs2/stages-$t-$o-$round.txt" $L timeout -k 5 300 taskset -c 2 ./copies/run benchmark-backend-source --only $o tiny.c > logs2/bench-$t-$o-$round.log 2>&1
            rm -f copies/run
        done
    done
done
echo done > logs2/status.txt
