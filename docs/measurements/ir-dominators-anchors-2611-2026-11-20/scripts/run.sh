#!/bin/bash
set -u
cd ~/buster-fast-bench/2611-claude
export EXCLUSIVE_OWNER=claude-2611 EXCLUSIVE_TITLE="Tier 1's CFG anchors read the IR's dominator tree (#2611)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2611
{
rm -rf repo
git clone --quiet --depth 1 --branch claude/stoic-ptolemy-ycprn2-2611 https://github.com/buster14a/buster.git repo || exit 1
cd repo && git log -1 --format='commit %H' && git apply ../knob.patch && git diff --stat || exit 1
~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh --config Release || exit 1
cp "$(readlink -f build/compiler)" ../compiler-knob
cd ..
~/buster-fast-bench/exclusive.sh ./measure.sh
echo "run exit $?"
} > run.log 2>&1
