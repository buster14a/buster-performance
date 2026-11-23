#!/bin/bash
cd ~/buster-fast-bench/2874-claude-volta
X="env EXCLUSIVE_OWNER=claude-2874-volta EXCLUSIVE_TITLE=buster#2874:Tier0-chains-reordered EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2874 $HOME/buster-fast-bench/exclusive.sh"
$X timeout -k 5 600 scripts/knobs.sh $PWD/bin/tune4 chain1 BUSTER_TIER0_CHAIN "0 1 2 4 8 16 31" 9 > results/chain1.log 2>&1
echo done > results/chain.done
