#!/bin/bash
# 2220-claude-e2: base (main 8c67a8d6) vs head (e2/2220-wide-switch b03b1d5ff712d1c98cc628955de7336b327aab1e) builds.
set -e
D=~/buster-fast-bench/2220-claude-e2
mkdir -p $D && cd $D
for t in base head; do
  [ -d $t ] || git clone -q https://github.com/buster14a/buster $t
done
git -C base fetch -q origin main && git -C base checkout -q 8c67a8d6
git -C head fetch -q origin e2/2220-wide-switch && git -C head checkout -q b03b1d5ff712d1c98cc628955de7336b327aab1e
cp ~/buster-fast-bench/frontend-baseline-claude/baseline/sqlite3.c $D/sqlite3.c
git -C base log -1 --format='base %H' ; git -C head log -1 --format='head %H'
