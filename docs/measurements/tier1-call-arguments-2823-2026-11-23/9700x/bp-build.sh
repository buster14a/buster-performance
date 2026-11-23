#!/bin/bash
# bp-build.sh: Release builds of base and head, each under its own hold of the 9700X's lock.
set -u
cd ~/buster-fast-bench/2823-claude
export EXCLUSIVE_OWNER=claude-2823 EXCLUSIVE_TITLE="buster #2823/#2610: Tier 1 allocation around calls" EXCLUSIVE_LINK=https://claude.ai/code/session_01Egbxnd67mUu2isTgj2N7JT
for t in base head; do
    (cd $t && ~/buster-fast-bench/exclusive.sh ./build.sh --config Release) > build-$t.log 2>&1
    echo "$t status $?" >> build-status.txt
done
