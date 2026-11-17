#!/bin/bash
# #2791's trees on the 9700X: a clone of buster, main's and the head's worktrees (each with its COMMIT), each built
# Release by ./build.sh under the lock, one hold per build. setup.sh BRANCH NAME=SHA...
set -u
cd ~/buster-fast-bench/2791-claude
export EXCLUSIVE_OWNER=claude-2791 EXCLUSIVE_TITLE="#2791 Tier 1: a select of a floating comparison is ucomis and cmovCC" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2791
branch=$1
shift
[ -d repo ] || git clone -q https://github.com/buster14a/buster.git repo
git -C repo fetch -q origin main "$branch"
for pair in "$@"; do
    name=${pair%%=*}
    sha=${pair#*=}
    [ -d $name ] || git -C repo worktree add -q --detach ../$name $sha
    echo $sha > $name/COMMIT
    (cd $name && ~/buster-fast-bench/exclusive.sh ./build.sh --config Release > build.log 2>&1; echo "build exit $?" >> build.log)
    test -x $name/build/compiler && echo "$name built" || echo "$name FAILED"
done
echo done > setup.done
