#!/bin/bash
# #2972: Tier 0's compile stages on tiny functions (experiment build: #2975's head plus stages.patch). Under the lock, CPU 2.
D=~/buster-fast-bench/2924-c-df-claude/c8y
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Tier 0 compile stages on tiny functions" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2972
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs copies
if [ ! -x compiler ]; then
    (cd src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build.log" 2>&1) || { echo "build failed" > logs/status.txt; exit 1; }
    cp src/build/compiler compiler
fi
for round in 1 2 3; do
    for o in vector scalar; do
        cp compiler copies/run
        BUSTER_TIER0_STAGES="$D/logs/stages-$o-$round.txt" $L timeout -k 5 300 taskset -c 2 ./copies/run benchmark-backend-source --only $o tiny.c > logs/bench-$o-$round.log 2>&1
        rm -f copies/run
    done
done
echo done > logs/status.txt
