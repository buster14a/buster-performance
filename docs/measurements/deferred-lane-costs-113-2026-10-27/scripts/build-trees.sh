#!/bin/bash
# Builds each tree's build/compiler as the 9700X job builds it (BUSTER_DEBUG_INFO=0), one lock hold per tree.
D=~/buster-fast-bench/deferred-113-lanes-claude
export EXCLUSIVE_OWNER=claude-113-lanes
export EXCLUSIVE_TITLE="#113 deferred reader lane costs: builds"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/113#issuecomment-6448574179"
for tree in "$@"; do
    ~/buster-fast-bench/exclusive.sh bash -c "cd $D/$tree && BUSTER_DEBUG_INFO=0 ./build.sh" > "$D/build-$tree.txt" 2>&1
    echo "$tree exit=$? $(date -Is)" >> "$D/builds.txt"
done
