#!/bin/bash
# 2367-claude-e2: base (main b935fa309c44b49c78ea3acd3e820735acb8b936) vs head (e2/2367-avx-abi 10fdf2d46a83253f984a7cbf7b149253fe45c5a2) builds.
set -e
D=~/buster-fast-bench/2367-claude-e2
mkdir -p $D && cd $D
for t in base head; do
  [ -d $t ] || git clone -q https://github.com/buster14a/buster $t
done
git -C base fetch -q origin main && git -C base checkout -q b935fa309c44b49c78ea3acd3e820735acb8b936
git -C head fetch -q origin e2/2367-avx-abi && git -C head checkout -q 10fdf2d46a83253f984a7cbf7b149253fe45c5a2
cp ~/buster-fast-bench/frontend-baseline-claude/baseline/sqlite3.c $D/sqlite3.c
git -C base log -1 --format='base %H' ; git -C head log -1 --format='head %H'
