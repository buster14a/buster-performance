#!/bin/bash
cd ~/buster-fast-bench/2874-claude-volta
X="env EXCLUSIVE_OWNER=claude-2874-volta EXCLUSIVE_TITLE=buster#2874:Tier0-pieces-C-D-three-way EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3486 $HOME/buster-fast-bench/exclusive.sh"
$X timeout -k 5 420 scripts/ab3.sh ab3-cd 30 base=$PWD/bin/base2 c=$PWD/bin/ahead cd=$PWD/bin/d1 > results/ab3-cd.log 2>&1
echo done > results/ab3.done
