#!/bin/bash
# Builds main's and head's trees, Release without debug info, each a lock hold of its own (the #1386 record's way).
B=~/buster-fast-bench/2678-claude
export EXCLUSIVE_OWNER=claude-2678 EXCLUSIVE_TITLE="Solve 2678 (int constants converted at run time)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2678
for tree in main-2ebfe68a head-e79a6338; do
    cd $B/$tree && BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh timeout -k 5 900 ./build.sh --config Release > build.log 2>&1
    echo "$tree exit $? $(tail -2 build.log | head -1)"
    sha256sum $B/$tree/build/compiler
done > $B/bench/builds.log 2>&1
echo done >> $B/bench/builds.log
