#!/bin/bash
# setup.sh: the bench directory's clone of buster and its Lua input (the other #2850 records' copy of Lua 5.4.8)
cd "$(dirname "$0")"
mkdir -p results trees inputs
test -d src || git clone -q https://github.com/buster14a/buster src
test -d inputs/lua-5.4.8 || cp -r ~/buster-fast-bench/868-claude/inputs/lua-5.4.8 inputs/
git -C src fetch -q origin main && git -C src log --oneline -1 origin/main
ls inputs/lua-5.4.8/src | wc -l
