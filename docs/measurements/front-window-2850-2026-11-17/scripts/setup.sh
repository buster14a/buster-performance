#!/bin/bash
# setup.sh: the bench directory's clone of buster (from the fact words' piece's, then the pull request's branch) and its
# Lua input
cd "$(dirname "$0")"
mkdir -p results trees inputs
test -d src || git clone -q ~/buster-fast-bench/2850-facts-claude/src src
git -C src remote set-url origin https://github.com/buster14a/buster
git -C src fetch -q origin main claude/compassionate-hamilton-0mvems && git -C src log --oneline -1 FETCH_HEAD
test -d inputs/lua-5.4.8 || cp -r ~/buster-fast-bench/868-claude/inputs/lua-5.4.8 inputs/
ls inputs/lua-5.4.8/src | wc -l
