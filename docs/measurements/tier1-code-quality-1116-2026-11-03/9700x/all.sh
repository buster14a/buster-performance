#!/usr/bin/env bash
# all.sh BASE HEAD: the trees' builds, then Lua's interpreter by each tree's --tier1 (lua.sh), then sqlite3.c's compile
# and speedtest1 (programs.sh); every step its own hold of the lock.
cd ~/buster-fast-bench/1116-claude || exit 1
./build.sh "$1" "$2" > all-build.log 2>&1
./lua.sh "lua-$2" "$1" "$2" > all-lua.log 2>&1
./programs.sh "$1" "$2" > all-programs.log 2>&1
echo done > all.done
