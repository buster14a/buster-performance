#!/bin/bash
cd ~/buster-fast-bench/2874-claude-volta
X="env EXCLUSIVE_OWNER=claude-2874-volta EXCLUSIVE_TITLE=buster#2874:Tier0-batch-limits EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2874 $HOME/buster-fast-bench/exclusive.sh"
$X timeout -k 5 600 scripts/scan.sh $PWD/bin/tune scan1 7 > results/scan1.log 2>&1
$X timeout -k 5 600 scripts/census2.sh $PWD/bin/tune census2-group32 32 41 > results/census2-group32.log 2>&1
$X timeout -k 5 600 scripts/census2.sh $PWD/bin/tune census2-group0 0 41 > results/census2-group0.log 2>&1
echo done > results/tune.done
