#!/usr/bin/env bash
# 2553 (current slots) runtime, step 0: the workspace. Inputs copied from #2592's (checked by their SHA-256 below), and
# clean clones of buster: base is main at b7d0b5ed, head the same commit with the change's source patch (head.patch,
# copied in beside this script).
set -eu
W=$HOME/buster-fast-bench/2553-claude-slots
BASE=b7d0b5edff73852852f0664c07fab61b00cad378
mkdir -p $W && cd $W
[ -d inputs ] || cp -a $HOME/buster-fast-bench/2592-claude/inputs inputs
(cd inputs && sha256sum sqlite/sqlite3.c st/speedtest1.c st/speedtest1-unity.c lua/*.lua ref/*.out lua/lua-5.4.8/src/lvm.c) > inputs.sha256
for t in base head; do
    rm -rf $t
    git clone -q https://github.com/buster14a/buster.git $t
    git -C $t checkout -q $BASE
done
git -C head apply $W/head.patch
echo "base $(git -C base rev-parse HEAD) head $(git -C head rev-parse HEAD) + head.patch $(sha256sum $W/head.patch | cut -d' ' -f1)" > revisions.txt
git -C head status --short >> revisions.txt
