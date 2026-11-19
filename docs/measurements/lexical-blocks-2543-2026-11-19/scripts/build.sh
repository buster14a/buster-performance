#!/bin/bash
# Builds base and new (#2543) as Release znver5 executables, each under its own hold of the 9700X lock.
cd ~/buster-fast-bench/2543-claude
export EXCLUSIVE_OWNER=claude-2543 EXCLUSIVE_TITLE="Unclaimed issues triage (#2543 debug blocks)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2543
for tree in base new; do
  (cd $tree && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh timeout -k 5 1500 ./build.sh --config Release > ../build-$tree.log 2>&1; echo "build exit $?" >> ../build-$tree.log)
done
echo done > builds.done
