#!/bin/bash
# Each build and the comparison take the 9700X's lock per run.
D=~/buster-fast-bench/2268-claude-e6
cd $D
export EXCLUSIVE_OWNER=claude-e6 EXCLUSIVE_TITLE='E6: tag name lists (#2268)' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2448
for t in base head; do ~/buster-fast-bench/exclusive.sh $D/build.sh $t; done
$D/run.sh
echo ALLDONE
