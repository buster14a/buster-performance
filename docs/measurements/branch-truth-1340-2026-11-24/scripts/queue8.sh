#!/bin/bash
# The merged base (main 5cd20eff) against the branch's head that merges it (0c6ae9dd): both builds, then two A/B holds.
cd ~/buster-fast-bench/1340-truth
export EXCLUSIVE_OWNER=claude-1340-truth EXCLUSIVE_TITLE="#1340 part 2: branch conditions' truth" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3569
X=~/buster-fast-bench/exclusive.sh
$X timeout -k 5 900 bin/build-one.sh base
$X timeout -k 5 900 bin/build-one.sh head
cp bin/compiler-base bin/compiler-base-5cd20eff; cp bin/compiler-head bin/compiler-head-0c6ae9dd
$X timeout -k 5 600 bin/ab.sh ab10 base head base:w
$X timeout -k 5 600 bin/ab.sh ab11 base head base:w
echo queue-done
