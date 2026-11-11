#!/bin/sh
set -e
D=~/buster-fast-bench/1840-claude-b3
if [ ! -d $D/.git ]; then
  if [ -d ~/buster-fast-bench/1840-claude/.git ]; then git clone -q --reference ~/buster-fast-bench/1840-claude --dissociate https://github.com/buster14a/buster $D; else git clone -q https://github.com/buster14a/buster $D; fi
fi
cd $D
git fetch -q origin ir/1840-shifts
git checkout -q -f FETCH_HEAD
git log --oneline -1
