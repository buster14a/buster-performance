#!/bin/bash
# #2924 C9g: x87_transfer_candidates' 64-byte-load kernel against the gather it replaces and the scalar twin, on the
# 9700X under the lock, CPU 2, Release, three runs of the experiment-only measure-c9g-x87.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924-c9g EXCLUSIVE_TITLE="buster #2924: IR value numbering, verified passes (C9g)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
G=~/buster-fast-bench/2924-c-df-claude
mkdir -p logs-x87
[ -d src-x87 ] || git clone -q --shared $G/c7gate/src src-x87
git -C src-x87 fetch -q https://github.com/buster14a/buster main
git -C src-x87 fetch -q "$D/x87.bundle" "+refs/heads/c9g-x87-measure:refs/heads/c9g-x87-measure"
git -C src-x87 checkout -q --detach c9g-x87-measure
git -C src-x87 rev-parse HEAD > logs-x87/commit.txt
(cd src-x87 && $L timeout -k 5 900 ./build.sh --config Release > "$D/logs-x87/build.log" 2>&1) || { echo "build failed" >> logs-x87/status.txt; exit 1; }
for run in 1 2 3; do
    $L timeout -k 5 280 taskset -c 2 src-x87/build/compiler measure-c9g-x87 > "$D/logs-x87/run$run.txt" 2>&1
    echo "run $run: $?" >> "$D/logs-x87/status.txt"
done
echo done >> "$D/logs-x87/status.txt"
