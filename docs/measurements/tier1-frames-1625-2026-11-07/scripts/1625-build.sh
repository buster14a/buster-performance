#!/bin/bash
# #1625: build main's compiler (cf38957a) for the 9700X, znver5, no debug information: one hold.
set -u
cd ~/buster-fast-bench/1623-claude
export EXCLUSIVE_OWNER=claude-1625 EXCLUSIVE_TITLE='Measure shrink-wrapping and shared call-save rows (#1625)' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1625
~/buster-fast-bench/exclusive.sh sh -c 'cd base && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh' > build-base.log 2>&1
echo "exit $?" >> build-base.log
touch build-base.done
