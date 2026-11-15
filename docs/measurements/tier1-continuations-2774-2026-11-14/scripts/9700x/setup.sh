#!/usr/bin/env bash
# 2774 runtime, step 0: the workspace. Inputs copied from #2768's (checked by their SHA-256 below), and clean clones of
# buster: base is main ee74e8e4 with #2773 merged (the branch's first commit), head the pull request's commit.
set -eu
W=$HOME/buster-fast-bench/2774-claude
BASE=${BASE_SHA:?}
HEAD=${HEAD_SHA:?}
mkdir -p $W && cd $W
[ -d inputs ] || cp -a $HOME/buster-fast-bench/2768-claude/inputs inputs
(cd inputs && sha256sum sqlite/sqlite3.c st/speedtest1.c st/speedtest1-unity.c lua/*.lua ref/*.out lua/lua-5.4.8/src/lvm.c) > inputs.sha256
rm -rf base head
git clone -q https://github.com/buster14a/buster.git base
git -C base fetch -q origin claude/sleepy-albattani-6yj7xf
git clone -q base head
git -C base checkout -q $BASE
git -C head checkout -q $HEAD
echo "base $(git -C base rev-parse HEAD) head $(git -C head rev-parse HEAD)" > revisions.txt
