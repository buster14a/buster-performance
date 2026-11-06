#!/bin/bash
# Builds the PR head in its own worktree, one hold for the build.
cd ~/buster-fast-bench/672-claude
git fetch -q origin claude/dreamy-franklin-mxyhql
[ -d head ] || git worktree add -q --detach head FETCH_HEAD
(cd head && git checkout -q --detach FETCH_HEAD && git log -1 --format=%H) > head-commit.txt
./lock.sh bash -c "cd head && ./build.sh" > head-build.log 2>&1
echo "build exit $?" >> head-build.log
cp head/build/compiler results/compiler-head
