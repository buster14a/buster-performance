#!/bin/bash
# #2924 C9g: the IR parser's line scan and the x87 transfer candidates, both paths, on the 9700X under the lock, CPU 2,
# Release, three runs of the experiment-only measure-c9g-paths (measure-paths.patch on main 968a085f).
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924-c9g EXCLUSIVE_TITLE="buster #2924: IR value numbering, verified passes (C9g)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
G=~/buster-fast-bench/2924-c-df-claude
mkdir -p logs-measure
[ -d src-measure ] || git clone -q --shared $G/c7gate/src src-measure
git -C src-measure fetch -q https://github.com/buster14a/buster main
git -C src-measure fetch -q "$D/measure.bundle" "+refs/heads/c9g-measure:refs/heads/c9g-measure"
git -C src-measure checkout -q --detach c9g-measure
git -C src-measure rev-parse HEAD > logs-measure/commit.txt
(cd src-measure && $L timeout -k 5 900 ./build.sh --config Release > "$D/logs-measure/build.log" 2>&1) || { echo "build failed" >> logs-measure/status.txt; exit 1; }
cd src-measure
for run in 1 2 3; do
    $L timeout -k 5 280 taskset -c 2 ./build/compiler measure-c9g-paths $(find tests -name '*.ir' | sort) > "$D/logs-measure/run$run.txt" 2>&1
    echo "run $run: $?" >> "$D/logs-measure/status.txt"
done
echo done >> "$D/logs-measure/status.txt"
