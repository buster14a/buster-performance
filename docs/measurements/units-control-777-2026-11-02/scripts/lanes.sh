#!/bin/bash
# test-lanes by main's and the head's builds, in turn, twice, unpinned as the 9700X job runs it.
set -u
W=$HOME/buster-fast-bench/777-claude
export TMPDIR=$W/tmp
lock() { EXCLUSIVE_OWNER=claude-777 EXCLUSIVE_TITLE="solve 777" EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/1186" ~/buster-fast-bench/exclusive.sh "$@"; }
for round in 1 2; do for TREE in "$@"; do
    cd $W/$TREE
    lock bash -c "./build/compiler test-lanes > $W/lanes-$TREE-$round.log 2>&1; echo \"$TREE round $round test-lanes: status \$?\""
    grep -E '^sessions' $W/lanes-$TREE-$round.log | sed 's/.*\(, [0-9]* wrong\)$/  sessions\1/'
done; done
echo lanes-finished
