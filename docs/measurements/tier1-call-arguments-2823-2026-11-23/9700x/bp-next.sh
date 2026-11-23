#!/bin/bash
# bp-next.sh: after bp-build.sh, head rebuilt with final.patch (Release, under the lock), then measure.sh final.
set -u
cd ~/buster-fast-bench/2823-claude
while pgrep -f bp-build.sh > /dev/null; do sleep 20; done
export EXCLUSIVE_OWNER=claude-2823 EXCLUSIVE_TITLE="buster #2823/#2610: Tier 1 allocation around calls" EXCLUSIVE_LINK=https://claude.ai/code/session_01Egbxnd67mUu2isTgj2N7JT
(cd head && git checkout -q -- . && git apply ../final.patch && ~/buster-fast-bench/exclusive.sh ./build.sh --config Release) > build-head-final.log 2>&1
echo "head-final status $?" >> build-status.txt
./measure.sh final > measure-final.log 2>&1
echo "measure status $?" >> build-status.txt
