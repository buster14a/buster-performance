#!/bin/bash
# The three census holds: every body, the bodies under 64 entries, the bodies of 512 or more.
cd ~/buster-fast-bench/2874-claude-volta
X="env EXCLUSIVE_OWNER=claude-2874-volta EXCLUSIVE_TITLE=buster#2874:Tier0-row-census-by-cause EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2874 $HOME/buster-fast-bench/exclusive.sh"
$X timeout -k 5 900 scripts/census.sh $PWD/bin/census census-all vector 41 > results/census-all.log 2>&1
BUSTER_TIER0_MAX=64 $X timeout -k 5 900 scripts/census.sh $PWD/bin/census census-small vector 41 > results/census-small.log 2>&1
BUSTER_TIER0_MIN=512 $X timeout -k 5 900 scripts/census.sh $PWD/bin/census census-large vector 41 > results/census-large.log 2>&1
echo done > results/census.done
