#!/bin/bash
# The branch's head 2c503ffb against main 5cd20eff (the tree it sits on), with the default warnings and with -w, in one hold.
cd ~/buster-fast-bench/1340-truth
export EXCLUSIVE_OWNER=claude-1340-truth EXCLUSIVE_TITLE="#1340 part 2: branch conditions' truth" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3569
X=~/buster-fast-bench/exclusive.sh
$X timeout -k 5 900 bin/build-one.sh head
cp bin/compiler-head bin/compiler-head-2c503ffb
$X timeout -k 5 900 bin/ab.sh ab12 base head base:w head:w
echo queue-done
