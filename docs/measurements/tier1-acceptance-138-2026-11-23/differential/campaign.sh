#!/usr/bin/env bash
# campaign.sh NAME SEED COUNT: #142's Csmith and YARPGen campaign at both tiers (Tier 0 by default, Tier 1 by
# --tier1 -fno-asynchronous-unwind-tables --tier1-report), COUNT programs of each generator from SEED.
set -u
name=$1; seed=$2; count=$3
T=$HOME/.cache/claude-138/tools
out=$HOME/.cache/claude-138/diff/$name
rm -rf "$out"; mkdir -p "$out"
C=$HOME/.cache/claude-138/campaign-compiler
nice "$C" test-differential --buster "$C" --tier0-default --tier1-arg --tier1 --tier1-arg -fno-asynchronous-unwind-tables --tier1-arg --tier1-report \
    --csmith "$T/csmith-install/bin/csmith" --csmith-include "$T/csmith-install/include" --yarpgen "$T/yarpgen-build/yarpgen" \
    --clang clang --generator both --seed "$seed" --count "$count" --timeout-ms 30000 --revision "$(cat $HOME/.cache/claude-138/diff/REVISION)" \
    --generator-revision "csmith 0cdc710315cfee9035e22ef4363ca479270d1934; yarpgen 1adb290f453505838f3aa33dc571f292b0c1810f" \
    --output "$out" > "$out.log" 2>&1
echo "exit $?" >> "$out.log"
