#!/bin/bash
# Builds base and head Release trees for the C4b A/B, each build under the 9700X's lock.
cd ~/buster-fast-bench/1447-c4b-claude
export EXCLUSIVE_OWNER=claude-c4b EXCLUSIVE_TITLE="C4b type sugar A/B" EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxnekHxD35FrgfVGaxb1
test -d head || git clone -q https://github.com/buster14a/buster head
(cd head && git fetch -q origin c4b/type-sugar && git checkout -q FETCH_HEAD && git log --oneline -1)
for t in base head; do
    (cd $t && ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1; echo "$t build exit $?"; tail -2 build.log)
done
echo built
