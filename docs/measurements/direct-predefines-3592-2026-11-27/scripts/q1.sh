#!/bin/bash
# q1.sh: the tiny ceiling: build it, then A/B the one-function unit. Each step its own hold.
d=~/buster-fast-bench/3586-claude2
cd $d
export EXCLUSIVE_OWNER=claude-3586 EXCLUSIVE_TITLE="Direct path arena tables (#3586)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3586
NO_TEST=1 ~/buster-fast-bench/exclusive.sh timeout -k 5 600 ./build-variant.sh tiny arena-map.patch tiny.patch
~/buster-fast-bench/exclusive.sh timeout -k 5 100 ./map1.sh tiny add tiny BUSTER_DIRECT_TINY=1 || true
~/buster-fast-bench/exclusive.sh timeout -k 5 300 ./ab-loop.sh 11 100 add main tiny tiny@BUSTER_DIRECT_TINY=1 > results/ab-tiny-add.txt 2>&1
echo Q1-DONE
