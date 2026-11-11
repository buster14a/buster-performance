#!/bin/bash
# 1838-claude-b7: base (checker/1838-version-statics 684f7d4) vs head (checker/1838-clones-per-version 2721ddc) builds.
set -e
D=~/buster-fast-bench/1838-claude-b7
mkdir -p $D && cd $D
for t in base head; do
  [ -d $t ] || git clone -q https://github.com/buster14a/buster $t
done
git -C base fetch -q origin checker/1838-version-statics && git -C base checkout -q 684f7d4
git -C head fetch -q origin checker/1838-clones-per-version && git -C head checkout -q 2721ddc
cp ~/buster-fast-bench/frontend-baseline-claude/baseline/sqlite3.c $D/sqlite3.c
git -C base log -1 --format='base %H' ; git -C head log -1 --format='head %H'
