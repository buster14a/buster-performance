#!/usr/bin/env bash
# campaign.sh NAME PASSES [scalar]: #142's Csmith and YARPGen campaign at both tiers, Tier 1 with --tier1-passes=PASSES.
set -u
name=$1
passes=$2
scalar=${3:-}
B=/home/user/buster
T=$HOME/.cache/claude-139/tools
out=$HOME/.cache/claude-139/diff/$name
rm -rf "$out"; mkdir -p "$out"
extra=()
[ -n "$scalar" ] && extra=(--tier1-arg --scalar)
nice "$B/build/campaign-compiler" test-differential --buster "$B/build/campaign-compiler" --tier0-default --tier1-arg --tier1 --tier1-arg "--tier1-passes=$passes" "${extra[@]}" \
    --tier1-arg -fno-asynchronous-unwind-tables --csmith "$T/csmith-install/bin/csmith" --csmith-include "$T/csmith-install/include" --yarpgen "$T/yarpgen-build/yarpgen" \
    --clang clang --generator both --seed 5000 --count 40 --timeout-ms 30000 --revision "$(cat $HOME/.cache/claude-139/diff/REVISION)" \
    --generator-revision "csmith 0cdc710315cfee9035e22ef4363ca479270d1934; yarpgen 1adb290f453505838f3aa33dc571f292b0c1810f" \
    --output "$out" > "$out.log" 2>&1
echo "exit $?" >> "$out.log"
