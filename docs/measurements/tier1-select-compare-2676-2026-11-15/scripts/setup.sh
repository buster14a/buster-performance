#!/bin/bash
# #2676's trees on the 9700X: a clone of buster, main's and the head's worktrees (each with its COMMIT), each built
# Release by ./build.sh under the lock, one hold per build.
set -u
cd ~/buster-fast-bench/2676-claude
export EXCLUSIVE_OWNER=claude-2676 EXCLUSIVE_TITLE="#2676 Tier 1: a select of a comparison is cmp and cmovCC" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2676
[ -d repo ] || git clone -q https://github.com/buster14a/buster.git repo
git -C repo fetch -q origin main claude/adoring-goldberg-xksrx6
for pair in "$@"; do
    name=${pair%%=*}
    sha=${pair#*=}
    [ -d $name ] || git -C repo worktree add -q --detach ../$name $sha
    echo $sha > $name/COMMIT
    (cd $name && ~/buster-fast-bench/exclusive.sh ./build.sh --config Release > build.log 2>&1; echo "build exit $?" >> build.log)
    test -x $name/build/compiler && echo "$name built" || echo "$name FAILED"
done
echo done > setup.done
