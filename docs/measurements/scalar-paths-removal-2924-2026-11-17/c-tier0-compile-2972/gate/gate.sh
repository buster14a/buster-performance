#!/bin/bash
# #2972: Tier 0 compile's gate again, with the fixed setup cut (fixes.patch on #2975's head e91cd2582) and the gate's
# compile knob (knob.patch): compile's ticks with its twin (0x1) against the vector path (0), five rounds in turn, on
# objects.sh's corpora plus tiny.c; then the warm benchmark on tiny.c. Under the lock, CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Tier 0 compile's gate with the fixed setup cut" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2972
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs ticks copies
if [ ! -x compiler-gate ]; then
    (cd src && $L timeout -k 5 1800 ./build.sh --config Release > "$D/logs/build.log" 2>&1) || { echo "build failed" >> logs/status.txt; exit 1; }
    cp src/build/compiler compiler-gate
fi
objects=/dev/shm/claude-2924-c8z
for round in 1 2 3 4 5; do
    for mask in 0 0x1; do
        rm -f "ticks/$mask-$round.txt"
        BUSTER_TIER0_SCALAR_AREAS=$mask BUSTER_TIER0_AREA_TICKS="$D/ticks/$mask-$round.txt" $L timeout -k 5 1500 taskset -c 2 "$D/objects.sh" "$D/compiler-gate" "$objects/t" "$D/src" > logs/ticks-$mask-$round.log 2>&1
        echo "ticks $mask $round: $(tr '\n' ' ' < logs/ticks-$mask-$round.log) $(wc -l < ticks/$mask-$round.txt) lines" >> logs/status.txt
        rm -rf "$objects"
    done
done
for round in 1 2 3; do
    for o in vector scalar; do
        cp compiler-gate copies/run
        $L timeout -k 5 300 taskset -c 2 ./copies/run benchmark-backend-source --only $o tiny.c > logs/bench-$o-$round.log 2>&1
        rm -f copies/run
    done
done
echo done >> logs/status.txt
