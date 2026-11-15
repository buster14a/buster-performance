#!/usr/bin/env bash
# 2784 runtime, step 0: the workspace. Inputs copied from #2592's (checked by their SHA-256 below), and clean clones of
# buster: base is main at b5099aa7, head the pull request's commit.
set -eu
W=$HOME/buster-fast-bench/2784-claude
BASE=b5099aa707e5766721c33a3eb292aee59c35d54d
HEAD=${HEAD_SHA:?}
mkdir -p $W && cd $W
[ -d inputs ] || cp -a $HOME/buster-fast-bench/2592-claude/inputs inputs
(cd inputs && sha256sum sqlite/sqlite3.c st/speedtest1.c st/speedtest1-unity.c lua/*.lua ref/*.out lua/lua-5.4.8/src/lvm.c) > inputs.sha256
for t in base head; do
    rm -rf $t
    git clone -q https://github.com/buster14a/buster.git $t
done
git -C base checkout -q $BASE
git -C head fetch -q origin claude/fervent-wozniak-barcil
git -C head checkout -q $HEAD
echo "base $(git -C base rev-parse HEAD) head $(git -C head rev-parse HEAD)" > revisions.txt
