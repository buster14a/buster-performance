#!/bin/bash
# Each build and the comparison take the 9700X's lock per run.
D=~/buster-fast-bench/1838-claude-b7
cd $D
export EXCLUSIVE_OWNER=claude-b7 EXCLUSIVE_TITLE='B7: GNU multiversioning (#1838)' EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxndTVe7u8sFsxbDhPmQ
for t in base head; do ~/buster-fast-bench/exclusive.sh $D/build.sh $t; done
$D/run.sh
echo ALLDONE
