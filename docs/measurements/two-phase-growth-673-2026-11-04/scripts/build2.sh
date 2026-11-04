#!/bin/bash
# #673: build main and the two-phase head for Zen 5, each its own lock hold.
B=~/buster-fast-bench/673-claude
export EXCLUSIVE_OWNER=claude-673 EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/673
for T in "$@"; do
    cd $B/$T && EXCLUSIVE_TITLE="673: build $T" BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1
    s=$?
    echo "$(date +%T) build $T status $s $(tail -1 build.log)" >> $B/build2.progress
    sleep 5
done
echo "$(date +%T) done" >> $B/build2.progress
