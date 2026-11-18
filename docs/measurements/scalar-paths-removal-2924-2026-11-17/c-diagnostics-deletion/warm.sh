#!/bin/bash
# #2924 C6: head plus warm.patch (benchmark-diagnostics warms each count for 10 ms rather than one pass), Release; six
# processes of the default, under the lock on CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: diagnostics' benchmark warm-up" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs/warm
git -C src-head checkout -q --detach c6-diagnostics && git -C src-head reset -q --hard && git -C src-head apply "$D/warm.patch" || { echo "patch failed" >> logs/warm/status.txt; exit 1; }
(cd src-head && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/warm/build.log" 2>&1) || { echo "build failed" >> logs/warm/status.txt; exit 1; }
cp src-head/build/compiler compilers/head-warm
for run in 1 2 3 4 5 6; do
    $L timeout -k 5 300 taskset -c 2 ./compilers/head-warm benchmark-diagnostics > logs/warm/run-$run.log 2>&1
    echo "run $run: $? $(grep -E ' (32|64): ' logs/warm/run-$run.log | sed 's/ TSC.*//' | tr '\n' ' ')" >> logs/warm/status.txt
done
date -u +%FT%TZ > logs/warm/.done
