#!/bin/bash
# #2924 C7's gate, the chain consumer's areas on synthetic functions: on --tier1 -c of the corpora, chain liveness (0x2)
# and chain allocation (0x4) retire the same user instructions as the control (debug2's counts), so the corpora don't
# tell their twins apart. Under the lock on CPU 2, with debug2.sh's executable:
# 1. benchmark-tier1-allocation, its own vector and scalar rows, three processes;
# 2. benchmark-tier1-select --only vector with each chain area's bit (0x2 liveness, 0x4 allocation, 0x8
#    rematerialization marks, 0x10 records) set alone and with none (0), three rounds in turn, each under perf stat's
#    user instructions.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: Tier 1's gate, the chain consumer on synthetic functions" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs/synth
for run in 1 2 3; do
    $L timeout -k 5 900 taskset -c 2 ./compiler-debug2 benchmark-tier1-allocation > logs/synth/allocation-$run.log 2>&1
    echo "allocation $run: $?" >> logs/synth/status.txt
done
for round in 1 2 3; do
    for mask in 0 0x2 0x4 0x8 0x10; do
        BUSTER_TIER1_SCALAR_AREAS=$mask $L timeout -k 5 900 taskset -c 2 perf stat -x, -e instructions:u -o "$D/logs/synth/select-$mask-$round.perf" ./compiler-debug2 benchmark-tier1-select --only vector > logs/synth/select-$mask-$round.log 2>&1
        echo "select $mask $round: $? $(grep instructions logs/synth/select-$mask-$round.perf | cut -d, -f1)" >> logs/synth/status.txt
    done
done
date -u +%FT%TZ > logs/synth/.done
