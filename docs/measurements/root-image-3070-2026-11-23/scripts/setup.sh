#!/usr/bin/env bash
# #3070: a fresh tree of main for this session, in its own directory. usage: setup.sh COMMIT
set -eu
D=$HOME/buster-fast-bench/3070-claude-euler
mkdir -p $D/bin $D/results
cd $D
if [ ! -d base ]; then git clone -q https://github.com/buster14a/buster base; fi
git -C base fetch -q origin main
git -C base checkout -q --detach "$1"
git -C base log --oneline | head -1
# The empty units and Lua's sources, from the earlier session's directory (read only).
[ -d empty ] || cp -r ~/buster-fast-bench/3070-claude/empty empty
[ -d lua ] || cp -r ~/buster-fast-bench/3070-claude/lua lua
ls empty | wc -l; ls lua/src/*.c | wc -l
