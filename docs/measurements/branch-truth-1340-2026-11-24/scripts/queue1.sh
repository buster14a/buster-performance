#!/bin/bash
# One locked run at a time: base's build, head's build, then the A/B.
cd ~/buster-fast-bench/1340-truth
export EXCLUSIVE_OWNER=claude-1340-truth EXCLUSIVE_TITLE="#1340 part 2: branch conditions' truth" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1340
X=~/buster-fast-bench/exclusive.sh
$X timeout -k 5 900 bin/build-one.sh base
$X timeout -k 5 900 bin/build-one.sh head
$X timeout -k 5 600 bin/ab.sh ab1 base head base:w
echo queue-done
