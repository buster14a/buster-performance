#!/bin/bash
set -e
D=~/buster-fast-bench/d8-claude
mkdir -p $D && cd $D
[ -d repo ] || git clone -q https://github.com/buster14a/buster.git repo
cd repo
git fetch -q origin '+refs/heads/main:refs/remotes/origin/main' '+refs/heads/d8/*:refs/remotes/origin/d8/*'
for t in "$@"; do n=${t%%:*}; r=${t#*:}; if [ -d ../$n ]; then git -C ../$n checkout -q --detach $r; else git worktree add -q --detach ../$n $r; fi; done
export EXCLUSIVE_OWNER=claude-d8 EXCLUSIVE_TITLE="D8: checker diagnostics PRs, base vs heads" EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxndzEpWbBb3xjo3m4ge
for t in "$@"; do n=${t%%:*}; (cd ../$n && git log --oneline -1 > rev.txt && ~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh > build.log 2>&1 && echo "built $n $(cat rev.txt)"); done
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > $D/predefines.h
echo SETUP-DONE
