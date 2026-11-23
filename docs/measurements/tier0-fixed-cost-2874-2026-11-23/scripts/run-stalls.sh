#!/bin/bash
cd ~/buster-fast-bench/2874-claude-volta
X="env EXCLUSIVE_OWNER=claude-2874-volta EXCLUSIVE_TITLE=buster#2874:Tier0-store-forwarding-stalls EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2874 $HOME/buster-fast-bench/exclusive.sh"
$X timeout -k 5 600 scripts/knobs2.sh $PWD/bin/tune5 stalls1 BUSTER_TIER0_CHAIN "0 32 64 128 256 512 1024 2016 2020" 9 > results/stalls1.log 2>&1
echo done > results/stalls.done
