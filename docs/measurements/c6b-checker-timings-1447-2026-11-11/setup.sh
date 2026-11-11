#!/bin/bash
# Builds each C6b merge and its first parent, one build per lock hold.
set -e
D=~/buster-fast-bench/1447-claude-d3
mkdir -p $D && cd $D
export EXCLUSIVE_OWNER=claude-1447-d3
export EXCLUSIVE_TITLE="#1447 D3: C6b checker PRs, base vs head"
export EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxndQMcsMYmMXdjncrCg
[ -d repo ] || git clone -q https://github.com/buster14a/buster repo
git -C repo fetch -q origin main
while read pr merge; do
  for side in base head; do
    t=$pr-$side
    if [ $side = base ]; then rev=$(git -C repo rev-parse $merge^1); else rev=$merge; fi
    [ -d $t ] || git -C repo worktree add -q --detach $D/$t $rev
    echo "$t $(git -C $t rev-parse HEAD)"
    if [ ! -x $t/build/compiler ]; then
      (cd $t && ~/buster-fast-bench/exclusive.sh ./build.sh > ../build-$t.log 2>&1) || { echo "build $t failed"; tail -5 build-$t.log; exit 1; }
    fi
  done
done < prs.txt
sha256sum */build/compiler > compilers.sha256
echo SETUP-DONE
