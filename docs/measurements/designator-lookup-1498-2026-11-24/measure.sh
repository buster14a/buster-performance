#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
. ./host.sh
mkdir -p raw
locked 60 ./fixtures.sh
{ date -u; uname -srmo; lscpu; clang --version; cmake --version; ninja --version; perf --version; } > raw/host.txt
sha256sum base/build/compiler head/build/compiler input/*.c input/*.expected > raw/sha256.txt
sources=()
while read -r shape fields rows group; do sources+=("$shape.c"); done < shapes.txt
(cd input && locked 90 taskset -c 2 clang -std=c11 -c "${sources[@]}")
verify() {
    local shape=$1 object=$2 result=$3
    objcopy --dump-section ".data=$result" "$object"
    cmp "input/$shape.expected" "$result"
    sha256sum "$result" >> "raw/$shape.sha256"
}
measure_shape() {
    local shape=$1 side round
    local -a sides
    verify "$shape" "input/$shape.o" "input/clang-$shape.bytes"
    for side in base head; do
        locked 90 taskset -c 2 "$side/build/compiler" -std=c11 -c "input/$shape.c" -o "input/$side-$shape.o"
        verify "$shape" "input/$side-$shape.o" "input/$side-$shape.bytes"
    done
    for round in {1..6}; do
        sides=(base head)
        if (( round % 2 == 0 )); then sides=(head base); fi
        for side in "${sides[@]}"; do
            echo "round $round  $shape  $side"
            locked 90 ./sample.sh "$side" "$shape" "$round"
        done
    done
}
# Each workload queues its next process independently. The host lock serializes all workloads.
pids=()
while read -r shape fields rows group; do
    measure_shape "$shape" > "raw/$shape.log" 2>&1 &
    pids+=("$!")
done < shapes.txt
status=0
for pid in "${pids[@]}"; do wait "$pid" || status=1; done
exit "$status"
