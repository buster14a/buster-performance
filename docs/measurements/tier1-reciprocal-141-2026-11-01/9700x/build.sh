#!/usr/bin/env bash
# build.sh TREE...: each tree's build (BUSTER_DEBUG_INFO=0), one hold of the shared lock each, logs in logs-build/.
. ~/buster-fast-bench/claude-141-reciprocal/common.sh
mkdir -p logs-build
for t in "$@"; do
    "$lock" bash -c "cd $t && BUSTER_DEBUG_INFO=0 ./build.sh > ../logs-build/$t.log 2>&1; echo \"exit \$?\" >> ../logs-build/$t.log"
    echo "$t: $(tail -2 logs-build/$t.log | tr '\n' ' ')"
done
