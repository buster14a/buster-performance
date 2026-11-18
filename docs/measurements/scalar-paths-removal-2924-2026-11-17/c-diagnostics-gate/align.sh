#!/bin/bash
# #2959: the gate's tree plus align.patch (digits and ranks aligned to 64 bytes; experiment build). Eight processes,
# ASLR on, and two with ASLR off, `benchmark-diagnostics --only selected` under perf stat, under the lock on CPU 2, and
# three of the default (both paths interleaved).
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: diagnostics' radix aligned (#2959)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2959
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs/align
if [ ! -d src-align ]; then git clone -q src src-align || exit 1; fi
git -C src-align checkout -q --detach 6eaf73cfd && git -C src-align reset -q --hard && git -C src-align apply "$D/counts.patch" && git -C src-align apply "$D/align.patch" || { echo "patch failed" >> logs/align/status.txt; exit 1; }
(cd src-align && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/align/build.log" 2>&1) || { echo "build failed" >> logs/align/status.txt; exit 1; }
cp src-align/build/compiler compiler-align
E=cycles,instructions,ls_misal_loads.ma64,ls_bad_status2.stli_other,ls_stlf
for run in 1 2 3 4 5 6 7 8; do
    $L timeout -k 5 300 taskset -c 2 perf stat -x, -e "$E" -o logs/align/perf-$run.csv ./compiler-align benchmark-diagnostics --only selected > logs/align/run-$run.log 2>&1
    echo "run $run: $? $(grep -E ' (32|257|4096) ' logs/align/run-$run.log | tr '\n' ' ')" >> logs/align/status.txt
done
for run in 1 2; do
    $L timeout -k 5 300 setarch -R taskset -c 2 ./compiler-align benchmark-diagnostics --only selected > logs/align/norandom-$run.log 2>&1
    echo "no aslr $run: $? $(grep -E ' (32|257|4096) ' logs/align/norandom-$run.log | tr '\n' ' ')" >> logs/align/status.txt
done
for run in 1 2 3; do
    $L timeout -k 5 300 taskset -c 2 ./compiler-align benchmark-diagnostics > logs/align/both-$run.log 2>&1
    echo "both $run: $?" >> logs/align/status.txt
done
date -u +%FT%TZ > logs/align/.done
