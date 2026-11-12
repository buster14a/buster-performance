#!/bin/bash
# 2268-claude-e6: base (main 8c67a8d6) vs head (e6/2268-tag-name-list 4c17b64069f49c01bc2367ef548ac1940dc104f6) builds.
set -e
D=~/buster-fast-bench/2268-claude-e6
mkdir -p $D && cd $D
for t in base head; do
  [ -d $t ] || git clone -q https://github.com/buster14a/buster $t
done
git -C base fetch -q origin main && git -C base checkout -q 8c67a8d6
git -C head fetch -q origin e6/2268-tag-name-list && git -C head checkout -q 4c17b64069f49c01bc2367ef548ac1940dc104f6
cp ~/buster-fast-bench/frontend-baseline-claude/baseline/sqlite3.c $D/sqlite3.c
git -C base log -1 --format='base %H' ; git -C head log -1 --format='head %H'
