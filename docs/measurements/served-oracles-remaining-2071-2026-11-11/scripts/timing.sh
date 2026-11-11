#!/bin/bash
# Interleaved local timings of the converted commands, before (claude/served-oracles-2071's executable: #2076's runs
# served, the fuzz batches and the units' runs as children) and after (this branch's: the fuzz batches and the units'
# runs served too). Each run gets an empty oracle cache in check mode (as each hosted job's starts empty) and the CPUs
# the inventory gives the command: part 4 at 1 CPU (taskset -c 2), the units at 2 (taskset -c 2,3).
# Usage: timing.sh BEFORE_EXECUTABLE AFTER_EXECUTABLE SERVER ROUNDS OUTPUT_DIRECTORY (from the buster checkout's root)
set -euo pipefail
before=$1
after=$2
server=$3
rounds=$4
output=$5
mkdir -p "$output"
units=(-target x86_64-pc-linux-gnu -march=x86-64 -Isrc -fwrapv -funsigned-char -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c src/buster/compiler/*_benchmark.c)
run()
{
    local name=$1 cpus=$2 parallel=$3
    shift 3
    local cache
    cache=$(mktemp -d)
    local start end status=0
    start=$(date +%s.%N)
    XDG_CACHE_HOME=$cache BUSTER_ORACLE_CACHE=check BUSTER_PARALLEL_CPUS=$parallel taskset -c "$cpus" "$@" > "$output/$name.log" 2>&1 || status=$?
    end=$(date +%s.%N)
    rm -rf "$cache"
    printf '%s\t%s\t%.2f\t%s\n' "$name" "$status" "$(echo "$end - $start" | bc)" "$(cut -d' ' -f1-3 /proc/loadavg)" | tee -a "$output/times.tsv"
}
for round in $(seq 1 "$rounds"); do
    run "part4-before-$round" 2 1 "$before" test-preprocessor --clang --jobs 1 --part 4/4 --clang-server "$server"
    run "part4-after-$round" 2 1 "$after" test-preprocessor --clang --jobs 1 --part 4/4 --clang-server "$server"
    run "units-before-$round" 2,3 2 "$before" test-preprocessor --clang "${units[@]}"
    run "units-after-$round" 2,3 2 "$after" test-preprocessor --clang "${units[@]}" --clang-server "$server"
done
