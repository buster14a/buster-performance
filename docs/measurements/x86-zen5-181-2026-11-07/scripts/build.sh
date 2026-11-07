#!/bin/bash
# Build the work tree on benchpress under the shared lock (#181).
cd ~/buster-fast-bench/181-claude/src || exit 1
export EXCLUSIVE_OWNER=claude-181 EXCLUSIVE_TITLE="Solve 181: Zen 5 model" EXCLUSIVE_LINK=https://claude.ai/code/session_01NNmNQsfeQGFgj9Zjd9KtQ8
~/buster-fast-bench/exclusive.sh env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh > ../build.log 2>&1
echo "build exit $?" >> ../build.log
