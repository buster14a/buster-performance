#!/bin/bash
# #2924 C4, experiment: does the timed analysis' place in the output arena move benchmark-dominators' synthetic figures?
# One executable (head c6eb0abe7 + pad.patch, experiment only), BUSTER_DOMINATOR_BENCHMARK_PAD unset or set, three
# processes of each in turn, each under the lock on CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: dominators' benchmark layout experiment" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs
if [ ! -d src ]; then git clone -q ../c4del/src-head src || exit 1; fi
git -C src checkout -q --detach c6eb0abe7209331c81338fe2a76c01061eb793c4 && git -C src apply "$D/pad.patch" || { echo "patch failed" >> logs/status.txt; exit 1; }
(cd src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build.log" 2>&1) || { echo "build failed" >> logs/status.txt; exit 1; }
cp src/build/compiler "$D/compiler-pad"
sha256sum compiler-pad > logs/compiler.sha256
for round in 1 2 3; do
    $L timeout -k 5 900 taskset -c 2 env -u BUSTER_DOMINATOR_BENCHMARK_PAD ./compiler-pad benchmark-dominators > logs/plain-$round.log 2>&1
    echo "plain $round: $?" >> logs/status.txt
    $L timeout -k 5 900 taskset -c 2 env BUSTER_DOMINATOR_BENCHMARK_PAD=1 ./compiler-pad benchmark-dominators > logs/pad-$round.log 2>&1
    echo "pad $round: $?" >> logs/status.txt
done
date -u +%FT%TZ > logs/.done
