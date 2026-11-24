#!/bin/bash
# The trees: base (the commit the branch sits on), head, and stage1, the head whose second stage (the integer
# constants' widths) is switched off by a throwaway edit, to tell what that stage is worth. Arguments: BASE HEAD.
set -eu
cd ~/buster-fast-bench/1340-reach
base=$1; head=$2
[ -d buster-base ] || git clone -q https://github.com/buster14a/buster buster-base
git -C buster-base fetch -q origin "$base" "$head"
git -C buster-base checkout -q --detach "$base"
for tree in head stage1; do
    [ -d buster-$tree ] || git -C buster-base worktree add -q --detach ../buster-$tree "$head"
    git -C buster-$tree checkout -q --detach "$head"
    git -C buster-$tree checkout -q -- .
done
f=buster-stage1/src/buster/compiler/c_check_common_reach_filter.c
sed -i 's/marks |= constants & (__mmask16)~widening;/marks |= constants | (widening \& 0);/; s/kept |= constants & (__mmask16)~widening;/kept |= constants | (widening \& 0);/' $f
git -C buster-stage1 diff --stat
git -C buster-stage1 diff > stage1.diff
for tree in base head stage1; do echo "$tree $(git -C buster-$tree rev-parse HEAD)"; done
