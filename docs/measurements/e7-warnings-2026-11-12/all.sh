#!/bin/bash
# Each build and the comparison take the 9700X's lock per run.
D=~/buster-fast-bench/e7-claude
cd $D
export EXCLUSIVE_OWNER=claude-e7 EXCLUSIVE_TITLE='E7: warnings left (#2217 #2218 #2409)' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2451
for t in base h2217 h2218 h2409u; do ~/buster-fast-bench/exclusive.sh $D/build.sh $t; done
$D/run.sh
echo ALLDONE
