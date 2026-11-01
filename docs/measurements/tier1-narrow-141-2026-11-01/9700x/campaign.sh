#!/usr/bin/env bash
# campaign.sh HEAD REVISION FIRST LAST [scalar]: #142's Csmith and YARPGen campaigns with HEAD's build at both tiers (Tier 0
# by default, Tier 1 by --tier1, with --scalar where asked), seeds FIRST to LAST by 2, 2 programs per generator a chunk,
# each chunk one hold of the shared lock, pinned to CPU 2 (step 6's queue-d.sh and queue-ds.sh).
. ~/buster-fast-bench/claude-141-remaining/common.sh
head=$1
revision=$2
first=$3
last=$4
scalar=${5:-}
out=$PWD/diff${scalar:+-scalar}-$head
mkdir -p $out
csmith=$HOME/research/tools/csmith-install/bin/csmith
include=$HOME/research/tools/csmith-install/include
yarpgen=$HOME/buster-fast-bench/codex138-tools/bin/yarpgen
extra=()
[ -n "$scalar" ] && extra=(--tier1-arg --scalar)
for seed in $(seq $first 2 $last); do
    "$lock" taskset -c 2 $head/build/compiler test-differential --buster $PWD/$head/build/compiler --tier0-default --tier1-arg --tier1 "${extra[@]}" \
        --tier1-arg -fno-asynchronous-unwind-tables --csmith $csmith --csmith-include $include --yarpgen $yarpgen --clang clang --generator both \
        --seed $seed --count 2 --timeout-ms 30000 --revision "$revision" \
        --generator-revision "csmith 0cdc710315cfee9035e22ef4363ca479270d1934; yarpgen 1adb290f453505838f3aa33dc571f292b0c1810f" \
        --output $out/chunk-$seed > $out/chunk-$seed.log 2>&1
    echo "exit $?" >> $out/chunk-$seed.log
done
echo done > $out/done-$first
