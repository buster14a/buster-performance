#!/bin/bash
# #877's matched comparison on the 9700X: the four measured trees and the timing driver, as worktrees of one clone.
# #1025: ebee03e2 (base) and 2ffcd901 (its merge). #1067: d3086da6 (base) and 59a48a56 (its merge). The driver, which
# runs ab, time-runs and nothing it times, is main ec5f0f6b. No lock: nothing here is timed or built.
set -eu
export LC_ALL=C
R=$HOME/buster-fast-bench/877-claude
mkdir -p $R/trees $R/bin $R/logs $R/results
[ -d $R/repo ] || git clone -q --no-checkout https://github.com/buster14a/buster.git $R/repo
git -C $R/repo fetch -q origin main
for c in ebee03e2 2ffcd901 d3086da6 59a48a56 ec5f0f6b; do
    [ -d $R/trees/tree-$c ] || git -C $R/repo worktree add -q --detach $R/trees/tree-$c $c
done
for c in ebee03e2 2ffcd901 d3086da6 59a48a56 ec5f0f6b; do
    printf '%s %s\n' $c "$(git -C $R/trees/tree-$c rev-parse HEAD)"
done > $R/logs/commits.txt
sha256sum $R/checker-offset.patch >> $R/logs/commits.txt
cat $R/logs/commits.txt
