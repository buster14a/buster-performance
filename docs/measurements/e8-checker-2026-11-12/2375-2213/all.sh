#!/bin/bash
# Each build and the comparison take the 9700X's lock per run.
D=~/buster-fast-bench/2375-claude-e8
cd $D
export EXCLUSIVE_OWNER=claude-e8 EXCLUSIVE_TITLE='E8: record casts and enum bases (#2375, #2213)' EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxngcM2C2LEUmibuXSqa
for t in base h2375 h2213; do ~/buster-fast-bench/exclusive.sh $D/build.sh $t; done
$D/run.sh
echo ALLDONE
