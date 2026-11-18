#!/bin/bash
# #2959, second form: the fix (fix2.patch: the radix sort's stack arrays aligned, and the small path counting each
# record's place 8 keys at a time) on main 6eaf73cfd, plus knob2.patch (experiment only: the cutoff from DIAG_CUTOFF,
# columns for 2,048 records, more benchmark counts). One executable; benchmark-diagnostics's default (the twin's
# insertion interleaved with diagnostic_sort) at cutoffs 256, 1,024 and 2,048, two processes each, under the lock on CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: diagnostics' cutoff (#2959)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2959
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs2
if [ ! -d src ]; then git clone -q ../c6gate/src src || exit 1; fi
git -C src checkout -q --detach 6eaf73cfd && git -C src reset -q --hard && git -C src apply "$D/fix2.patch" && git -C src apply "$D/knob2.patch" || { echo "patch failed" >> logs2/status.txt; exit 1; }
(cd src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs2/build.log" 2>&1) || { echo "build failed" >> logs2/status.txt; exit 1; }
cp src/build/compiler compiler-knob2
for run in 1 2; do
    for cutoff in 256 1024 2048; do
        DIAG_CUTOFF=$cutoff $L timeout -k 5 300 taskset -c 2 ./compiler-knob2 benchmark-diagnostics > logs2/cutoff-$cutoff-$run.log 2>&1
        echo "cutoff $cutoff $run: $?" >> logs2/status.txt
    done
done
date -u +%FT%TZ > logs2/.done
