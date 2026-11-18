#!/bin/bash
# #2924 C7's gate, the two allocations that read even: the ticks of --tier1 -c of sqlite3.c, Lua and musl with every
# area on vector (0), the chain consumer's allocation alone on scalar (0x4) and the CFG allocation alone (0x40), five
# rounds in turn, under the lock on CPU 2, with run.sh's executable.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: Tier 1's gate, the allocations" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs/alloc ticks/alloc
objects=/dev/shm/claude-2924-c7alloc
for round in 1 2 3 4 5; do
    for mask in 0 0x4 0x40; do
        rm -f "ticks/alloc/$mask-$round.txt"
        BUSTER_TIER1_SCALAR_AREAS=$mask BUSTER_TIER1_AREA_TICKS="$D/ticks/alloc/$mask-$round.txt" $L timeout -k 5 1500 taskset -c 2 "$D/objects.sh" "$D/compiler-gate" "$objects" > logs/alloc/ticks-$mask-$round.log 2>&1
        echo "ticks $mask $round: $(tr '\n' ' ' < logs/alloc/ticks-$mask-$round.log) $(wc -l < ticks/alloc/$mask-$round.txt) lines" >> logs/alloc/status.txt
        rm -rf "$objects"
    done
done
date -u +%FT%TZ > logs/alloc/.done
