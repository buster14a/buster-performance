#!/bin/bash
# #2924 C8's gate, each area alone: the ticks of every area with compile's bit alone (0x1) and validation's alone (0x2)
# against none (0), five rounds in turn, with run.sh's executable and objects.sh. Flipping all four at once (0xf) left
# each area to run after the others' scalar twins, whose code and data the caches then hold (#2972).
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: Tier 0's gate, each area alone" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2972
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs/alone ticks-alone
objects=/dev/shm/claude-2924-c8gate-alone
for round in 1 2 3 4 5; do
    for mask in 0 0x1 0x2; do
        rm -f "ticks-alone/$mask-$round.txt"
        BUSTER_TIER0_SCALAR_AREAS=$mask BUSTER_TIER0_AREA_TICKS="$D/ticks-alone/$mask-$round.txt" $L timeout -k 5 1500 taskset -c 2 "$D/objects.sh" "$D/compiler-gate" "$objects/t" "$D/src" > logs/alone/ticks-$mask-$round.log 2>&1
        echo "ticks $mask $round: $(tr '\n' ' ' < logs/alone/ticks-$mask-$round.log) $(wc -l < ticks-alone/$mask-$round.txt) lines" >> logs/alone/status.txt
        rm -rf "$objects"
    done
done
date -u +%FT%TZ > logs/alone/.done
