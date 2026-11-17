#!/usr/bin/env bash
# The final head's instruction counts: Lua's five scripts and speedtest1 by its compiler, under callgrind.
set -u
cd "$(dirname "$0")"
C=$HOME/.cache/claude-2791
./buildlua.sh $C/head-compiler-final $C/counts/lua-final > lua-final.log 2>&1
./luacount.sh lua-final > lua-final.txt 2>&1
./st.sh $C/head-compiler-final st-final > st-final.txt 2>&1
echo done > final.done
