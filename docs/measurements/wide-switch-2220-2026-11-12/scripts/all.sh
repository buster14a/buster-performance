#!/bin/bash
# Each build and the comparison take the 9700X's lock per run.
D=~/buster-fast-bench/2220-claude-e2
cd $D
export EXCLUSIVE_OWNER=claude-e2 EXCLUSIVE_TITLE='E2: calling convention, ABI and wide types (#2220)' EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxngLkubh4Z2ro3Q5ZEQ
for t in base head; do ~/buster-fast-bench/exclusive.sh $D/build.sh $t; done
$D/run.sh
echo ALLDONE
