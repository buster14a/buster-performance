#!/usr/bin/env bash
# both.sh COMPILER DIR: speedtest1 and Lua counts for COMPILER into DIR.
set -u
B=$1; d=$2
mkdir -p $d
bash ~/.cache/claude-2593/scripts/st.sh $B $d/st > $d/st.txt 2>&1 &
( bash ~/.cache/claude-2593/scripts/buildlua.sh $B $d/lua && bash ~/.cache/claude-2593/scripts/luacount.sh $d/lua ) > $d/lua.txt 2>&1
wait
cat $d/st.txt $d/lua.txt
