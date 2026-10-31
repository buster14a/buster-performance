#!/usr/bin/env bash
# queue-ds.sh HEAD REVISION: queue-d.sh's campaign with Tier 1's scalar path alone (--tier1 --scalar), seeds 3200 to 3218, at both tiers (Tier 0 by default,
# Tier 1 by --tier1), 2 programs per generator a chunk, each chunk one hold of the shared lock, pinned to CPU 2.
set -u
cd ~/buster-fast-bench/claude-140-cfg || exit 1
head=$1
revision=$2
out=$PWD/diff-scalar-$head
mkdir -p $out
export EXCLUSIVE_OWNER=claude-140-cfg
export EXCLUSIVE_TITLE="Tier 1 selection walks #140: #142 campaign, scalar path"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/977
lock=~/buster-fast-bench/exclusive.sh
csmith=$HOME/research/tools/csmith-install/bin/csmith
include=$HOME/research/tools/csmith-install/include
yarpgen=$HOME/buster-fast-bench/codex138-tools/bin/yarpgen
unset CPATH C_INCLUDE_PATH
for seed in $(seq 3200 2 3218); do
    "$lock" taskset -c 2 $head/build/compiler test-differential --buster $PWD/$head/build/compiler --tier0-default --tier1-arg --tier1 --tier1-arg --scalar \
        --tier1-arg -fno-asynchronous-unwind-tables --csmith $csmith --csmith-include $include --yarpgen $yarpgen --clang clang --generator both \
        --seed $seed --count 2 --timeout-ms 30000 --revision "$revision" \
        --generator-revision "csmith 0cdc710315cfee9035e22ef4363ca479270d1934; yarpgen 1adb290f453505838f3aa33dc571f292b0c1810f" \
        --output $out/chunk-$seed > $out/chunk-$seed.log 2>&1
    echo "exit $?" >> $out/chunk-$seed.log
done
echo done > $out/done
