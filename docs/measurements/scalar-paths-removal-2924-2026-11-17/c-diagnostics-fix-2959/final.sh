#!/bin/bash
# #2959, the final form: fix3.patch (the radix sort's stack arrays aligned; the small path counting each record's place
# 8 keys at a time, its key columns taken by permutes; the cutoff at 512) on main 6eaf73cfd, plus counts3.patch
# (experiment only: more benchmark counts). benchmark-diagnostics's default (the twin's insertion interleaved with
# diagnostic_sort), three processes, and three of --only selected --after-scalar 100, under the lock on CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: diagnostics' final form (#2959)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2959
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs3
git -C src checkout -q --detach 6eaf73cfd && git -C src reset -q --hard && git -C src apply "$D/fix3.patch" && git -C src apply "$D/counts3.patch" || { echo "patch failed" >> logs3/status.txt; exit 1; }
(cd src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs3/build.log" 2>&1) || { echo "build failed" >> logs3/status.txt; exit 1; }
cp src/build/compiler compiler-final
for run in 1 2 3; do
    $L timeout -k 5 300 taskset -c 2 ./compiler-final benchmark-diagnostics > logs3/both-$run.log 2>&1
    echo "both $run: $?" >> logs3/status.txt
    $L timeout -k 5 300 taskset -c 2 ./compiler-final benchmark-diagnostics --only selected --after-scalar 100 > logs3/after-$run.log 2>&1
    echo "after $run: $?" >> logs3/status.txt
done
date -u +%FT%TZ > logs3/.done
