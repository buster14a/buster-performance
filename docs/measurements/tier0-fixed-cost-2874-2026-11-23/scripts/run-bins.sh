#!/bin/bash
cd ~/buster-fast-bench/2874-claude-volta
X="env EXCLUSIVE_OWNER=claude-2874-volta EXCLUSIVE_TITLE=buster#2874:Tier0-passes-by-function-size EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2874 $HOME/buster-fast-bench/exclusive.sh"
$X timeout -k 5 420 scripts/bins.sh $PWD/bin/tune4 bins1 > results/bins1.log 2>&1
echo done > results/bins.done
