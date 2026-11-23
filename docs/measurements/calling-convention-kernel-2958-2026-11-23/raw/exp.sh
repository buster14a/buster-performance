#!/bin/bash
# usage: exp.sh NAME  (patch on stdin was saved to NAME.patch); builds exp tree at head+63e0fbf3-equivalent + patch, runs benchmark once
set -e
D=~/buster-fast-bench/2958-claude; N=$1
cd $D
[ -d exp ] || git clone -q head exp
git -C exp checkout -q -f 84bacda191052ba7f03d37af73e895a33a038ecd
git -C exp apply $D/$N.patch
L="EXCLUSIVE_OWNER=claude-2958 EXCLUSIVE_TITLE=PR3364-calling-convention-experiment EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3364"
(cd exp && env $L ~/buster-fast-bench/exclusive.sh ./build.sh --config Release) > build-$N.log 2>&1
cp exp/build/compiler compiler-$N
env $L ~/buster-fast-bench/exclusive.sh taskset -c 2 $D/compiler-$N benchmark-calling-convention --only assignment > bench-$N.log 2>&1
echo done > done-$N
