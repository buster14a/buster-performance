#!/bin/bash
# #2924 C9's gate, each area alone: LICM's bit (0x80) with --tier1-passes=+all, where all twelve at once read 0.61 on
# the largest functions; value numbering's (0x8) and promotion's (0x10), even at the smallest sizes, in both
# configurations; each against no bit (0), five rounds in turn, with run.sh's executable and objects.sh.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the IR's gate, each area alone" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs/alone ticks-alone
objects=/dev/shm/claude-2924-c9gate-alone
for round in 1 2 3 4 5; do
    for config in all default; do
        if [ $config = all ]; then export EXTRA=--tier1-passes=+all; masks="0 0x80 0x8 0x10"; else export EXTRA=; masks="0 0x8 0x10"; fi
        for mask in $masks; do
            rm -f "ticks-alone/$config-$mask-$round.txt"
            BUSTER_IR_SCALAR_AREAS=$mask BUSTER_IR_AREA_TICKS="$D/ticks-alone/$config-$mask-$round.txt" $L timeout -k 5 1500 taskset -c 2 "$D/objects.sh" "$D/compiler-gate" "$objects/t" > logs/alone/ticks-$config-$mask-$round.log 2>&1
            echo "ticks $config $mask $round: $(tr '\n' ' ' < logs/alone/ticks-$config-$mask-$round.log) $(wc -l < ticks-alone/$config-$mask-$round.txt) lines" >> logs/alone/status.txt
            rm -rf "$objects"
        done
    done
done
date -u +%FT%TZ > logs/alone/.done
