#!/bin/bash
# campaign.sh FIRST LAST: #142's Csmith and YARPGen campaign with src's build at both tiers (Tier 0 by default, Tier 1
# by --tier1 -fno-asynchronous-unwind-tables --tier1-report) against clang -O0 and -O2, as the #1116 record's
# campaign.sh ran it: seeds FIRST to LAST by 2, two programs per generator a chunk, a 30 s timeout, each chunk one hold
# of the lock, pinned to CPU 2, with a pause between holds for the other sessions and CI. results/campaign/chunk-SEED.log;
# the generated programs and each step's output stay in scratch/campaign. A STOP file in this directory ends it.
set -u
cd "$(dirname "$0")"
first=$1; last=$2
out=$PWD/results/campaign
work=$PWD/scratch/campaign
mkdir -p "$out" "$work"
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
csmith=$HOME/research/tools/csmith-install/bin/csmith
include=$HOME/research/tools/csmith-install/include
yarpgen=$HOME/buster-fast-bench/codex138-tools/bin/yarpgen
sha256sum "$csmith" "$yarpgen" src/build/compiler > "$out/tools.sha256"
for seed in $(seq "$first" 2 "$last"); do
    [ -e STOP ] && break
    ./lock.sh taskset -c 2 src/build/compiler test-differential --buster "$PWD/src/build/compiler" --tier0-default --tier1-arg --tier1 \
        --tier1-arg -fno-asynchronous-unwind-tables --tier1-arg --tier1-report --csmith "$csmith" --csmith-include "$include" --yarpgen "$yarpgen" --clang clang \
        --generator both --seed "$seed" --count 2 --timeout-ms 30000 --revision "$(cat src.commit)" \
        --generator-revision "csmith 0cdc710315cfee9035e22ef4363ca479270d1934; yarpgen 1adb290f453505838f3aa33dc571f292b0c1810f" \
        --output "$work/chunk-$seed" > "$out/chunk-$seed.log" 2>&1
    echo "exit $?" >> "$out/chunk-$seed.log"
    sleep 20
done
# One line per generated program: chunk, program, result, then each step's status.
for result in "$work"/chunk-*/campaign-*/*/result.json; do
    dir=$(dirname "$result"); program=$(basename "$dir"); chunk=$(basename "$(dirname "$(dirname "$dir")")")
    status=$(sed -n 's/.*"status":"\([^"]*\)".*/\1/p' "$result"); signature=$(sed -n 's/.*"signature":"\([^"]*\)".*/\1/p' "$result")
    steps=""
    for step in buster-tier0-compile buster-tier0-run buster-tier1-compile buster-tier1-run clang-o0-compile clang-o0-run clang-o2-compile clang-o2-run; do
        [ -f "$dir/$step.json" ] && steps="$steps $step=$(sed -n 's/.*"status":"\([^"]*\)","exit_code":\([0-9-]*\).*/\1:\2/p' "$dir/$step.json")"
    done
    echo "$chunk $program $status sig=${signature:-none}$steps"
done > "$out/campaign.tsv"
date -u +%FT%TZ > "$out/done-$first"
