#!/bin/bash
cd ~/buster-fast-bench/2874-claude-volta
X="env EXCLUSIVE_OWNER=claude-2874-volta EXCLUSIVE_TITLE=buster#2874:Tier0-pieces-on-merged-main EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3486 $HOME/buster-fast-bench/exclusive.sh"
$X timeout -k 5 420 scripts/ab3.sh ab3-merged 30 base=$PWD/bin/base3 merged=$PWD/bin/merged > results/ab3-merged.log 2>&1
echo done > results/ab3m.done
