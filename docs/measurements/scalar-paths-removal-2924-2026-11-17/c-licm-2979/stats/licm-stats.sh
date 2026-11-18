#!/bin/bash
# #2979: LICM's sweeps, visits, eligible loops and fallbacks per function, vector path (0) and twin (0x80), with
# --tier1-passes=+all: the gate's knob plus the statistics (knob-licm.patch), one round each.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="LICM's sweeps on large functions" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2979
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs/licm ticks-licm
git -C src reset -q --hard && git -C src apply "$D/knob-licm.patch" || { echo "patch failed" >> logs/licm/status.txt; exit 1; }
(cd src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/licm/build.log" 2>&1) || { echo "build failed" >> logs/licm/status.txt; exit 1; }
cp src/build/compiler compiler-licm
objects=/dev/shm/claude-2924-c9licm
export EXTRA=--tier1-passes=+all
for mask in 0 0x80; do
    rm -f "ticks-licm/all-$mask-1.txt"
    BUSTER_IR_SCALAR_AREAS=$mask BUSTER_IR_AREA_TICKS="$D/ticks-licm/all-$mask-1.txt" $L timeout -k 5 1500 taskset -c 2 "$D/objects.sh" "$D/compiler-licm" "$objects/t" > logs/licm/ticks-$mask.log 2>&1
    echo "ticks $mask: $(tr '\n' ' ' < logs/licm/ticks-$mask.log) $(wc -l < ticks-licm/all-$mask-1.txt) lines" >> logs/licm/status.txt
    rm -rf "$objects"
done
date -u +%FT%TZ > logs/licm/.done
