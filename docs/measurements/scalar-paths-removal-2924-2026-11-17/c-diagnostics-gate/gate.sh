#!/bin/bash
# #2924 C6, diagnostics' gate: benchmark-diagnostics on main 6eaf73cfd plus counts.patch (experiment only: more record
# counts between the insertion cutoff, 256, and 4,096), Release, under the lock on CPU 2. Three processes each of the
# default (both paths interleaved), --only scalar and --only selected, and of --only selected --after-scalar 100.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: diagnostics' gate" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
P=$D/../c3pr
mkdir -p logs
if [ ! -d src ]; then git clone -q $P/src-main src || exit 1; fi
git -C src fetch -q https://github.com/buster14a/buster main && git -C src checkout -q --detach 6eaf73cfd && git -C src apply "$D/counts.patch" || { echo "patch failed" >> logs/status.txt; exit 1; }
(cd src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build.log" 2>&1) || { echo "build failed" >> logs/status.txt; exit 1; }
cp src/build/compiler compiler-gate
sha256sum compiler-gate > logs/compiler.sha256
for round in 1 2 3; do
    $L timeout -k 5 900 taskset -c 2 ./compiler-gate benchmark-diagnostics > logs/both-$round.log 2>&1; echo "both $round: $?" >> logs/status.txt
    $L timeout -k 5 900 taskset -c 2 ./compiler-gate benchmark-diagnostics --only scalar > logs/scalar-$round.log 2>&1; echo "scalar $round: $?" >> logs/status.txt
    $L timeout -k 5 900 taskset -c 2 ./compiler-gate benchmark-diagnostics --only selected > logs/selected-$round.log 2>&1; echo "selected $round: $?" >> logs/status.txt
    $L timeout -k 5 900 taskset -c 2 ./compiler-gate benchmark-diagnostics --only selected --after-scalar 100 > logs/selected-after-$round.log 2>&1; echo "selected after 100 $round: $?" >> logs/status.txt
done
date -u +%FT%TZ > logs/.done
