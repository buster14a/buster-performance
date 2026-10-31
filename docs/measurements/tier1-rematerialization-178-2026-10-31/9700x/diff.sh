#!/usr/bin/env bash
# diff.sh TREE REVISION FIRST LAST: #142's Csmith and YARPGen campaigns with TREE's build at both tiers (Tier 0 by
# default, Tier 1 by --tier1, which rematerializes, #178), 2 programs per generator a chunk, seeds FIRST to LAST by 2,
# each chunk one hold of the shared lock, pinned to CPU 2.
set -u
cd ~/buster-fast-bench/claude-178-remat || exit 1
tree=$1
revision=$2
first=$3
last=$4
out=$PWD/diff-$tree
mkdir -p $out
export EXCLUSIVE_OWNER=claude-178-remat
export EXCLUSIVE_TITLE="Tier 1 rematerialization in linear scan (#178): #142's campaigns"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/178
lock=~/buster-fast-bench/exclusive.sh
csmith=$HOME/research/tools/csmith-install/bin/csmith
include=$HOME/research/tools/csmith-install/include
yarpgen=$HOME/buster-fast-bench/codex138-tools/bin/yarpgen
unset CPATH C_INCLUDE_PATH
for seed in $(seq $first 2 $last); do
    "$lock" taskset -c 2 $tree/build/compiler test-differential --buster $PWD/$tree/build/compiler --tier0-default --tier1-arg --tier1 \
        --tier1-arg -fno-asynchronous-unwind-tables --csmith $csmith --csmith-include $include --yarpgen $yarpgen --clang clang --generator both \
        --seed $seed --count 2 --timeout-ms 30000 --revision "$revision" \
        --generator-revision "csmith 0cdc710315cfee9035e22ef4363ca479270d1934; yarpgen 1adb290f453505838f3aa33dc571f292b0c1810f" \
        --output $out/chunk-$seed > $out/chunk-$seed.log 2>&1
    echo "exit $?" >> $out/chunk-$seed.log
done
echo done > $out/done
