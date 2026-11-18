#!/bin/bash
# #2959: the fix (fix.patch: the radix sort's stack arrays aligned, the 128-bit-key insertion as the small path) on main
# 6eaf73cfd, plus knob.patch (experiment only: the cutoff from DIAG_CUTOFF, more benchmark counts). One executable;
# benchmark-diagnostics's default (the twin's insertion interleaved with diagnostic_sort) at cutoffs 256, 384, 416,
# 448 and 512, two processes each, under the lock on CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: diagnostics' cutoff (#2959)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2959
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs
if [ ! -d src ]; then git clone -q ../c6gate/src src || exit 1; fi
git -C src checkout -q --detach 6eaf73cfd && git -C src reset -q --hard && git -C src apply "$D/fix.patch" && git -C src apply "$D/knob.patch" || { echo "patch failed" >> logs/status.txt; exit 1; }
(cd src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build.log" 2>&1) || { echo "build failed" >> logs/status.txt; exit 1; }
cp src/build/compiler compiler-knob
for run in 1 2; do
    for cutoff in 256 384 416 448 512; do
        DIAG_CUTOFF=$cutoff $L timeout -k 5 300 taskset -c 2 ./compiler-knob benchmark-diagnostics > logs/cutoff-$cutoff-$run.log 2>&1
        echo "cutoff $cutoff $run: $?" >> logs/status.txt
    done
done
date -u +%FT%TZ > logs/.done
