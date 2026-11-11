#!/bin/bash
# Builds base (main a8855682) and head (c4b/1842-padding-sugar) Release trees for #1842's 1b A/B, each under the lock.
B=~/buster-fast-bench/1842-padding-claude
mkdir -p $B && cd $B
export EXCLUSIVE_OWNER=claude-c4b EXCLUSIVE_TITLE="C4b #1842 1b padding sugar A/B" EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxnekHxD35FrgfVGaxb1
for t in base head; do
    test -d $t || git clone -q https://github.com/buster14a/buster $t
done
(cd base && git fetch -q origin a8855682c && git checkout -q FETCH_HEAD 2>/dev/null || git checkout -q a8855682; git log --oneline -1)
(cd head && git fetch -q origin c4b/1842-padding-sugar && git checkout -q FETCH_HEAD && git log --oneline -1)
for t in base head; do
    (cd $t && ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1; echo "$t build exit $?"; tail -1 build.log)
done
