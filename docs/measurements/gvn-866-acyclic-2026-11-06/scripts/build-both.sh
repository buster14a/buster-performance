#!/bin/bash
# Builds base and cand with the benchmark flags, each under the shared lock, one at a time.
set -e
cd ~/buster-fast-bench/866-claude
export EXCLUSIVE_OWNER=claude-866 EXCLUSIVE_TITLE="Solve 866 (GVN acyclic numbering)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/866
for tree in "$@"; do
    (cd "$tree" && BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > ../build-$tree.log 2>&1) || { echo "build $tree failed"; tail -20 build-$tree.log; exit 1; }
    tail -1 build-$tree.log
done
