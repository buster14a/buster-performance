#!/bin/bash
# #877, second campaign: main 5fb062a4 against two ways to read the lowering's local_map without #1067's branch on its
# bitset: B, the fill restored and the bitset removed (variant-b.patch); C, the bitset read branch-free through a
# sentinel entry (variant-c.patch). main has BUSTER_CHECKER_OFFSET (#1233), so nothing is backported. No lock.
set -eu
export LC_ALL=C
R=$HOME/buster-fast-bench/877-claude; V=$R/v2
mkdir -p $V/trees $V/bin $V/logs $V/results
git -C $R/repo fetch -q origin main
for t in main b c; do
    [ -d $V/trees/tree-$t ] || git -C $R/repo worktree add -q --detach $V/trees/tree-$t 5fb062a4
done
git -C $V/trees/tree-b apply $V/variant-b.patch
git -C $V/trees/tree-c apply $V/variant-c.patch
for t in main b c; do printf '%s %s %s\n' $t "$(git -C $V/trees/tree-$t rev-parse HEAD)" "$(git -C $V/trees/tree-$t diff | sha256sum | cut -c1-16)"; done > $V/logs/commits.txt
sha256sum $V/variant-*.patch >> $V/logs/commits.txt
cat $V/logs/commits.txt
