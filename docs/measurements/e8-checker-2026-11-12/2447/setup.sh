#!/bin/bash
# 2230-claude-e8: base (main 8c67a8d6) vs head (e8/2230-atomic-casts f20fd0fd5e55ac0fcf12255a23b3e8746f6bb261) builds.
set -e
D=~/buster-fast-bench/2230-claude-e8
mkdir -p $D && cd $D
for t in base head; do
  [ -d $t ] || git clone -q https://github.com/buster14a/buster $t
done
git -C base fetch -q origin main && git -C base checkout -q 8c67a8d6
git -C head fetch -q origin e8/2230-atomic-casts && git -C head checkout -q f20fd0fd5e55ac0fcf12255a23b3e8746f6bb261
cp ~/buster-fast-bench/frontend-baseline-claude/baseline/sqlite3.c $D/sqlite3.c
git -C base log -1 --format='base %H' ; git -C head log -1 --format='head %H'
