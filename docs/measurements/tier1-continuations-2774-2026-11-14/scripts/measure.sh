#!/usr/bin/env bash
# measure.sh NAME [env...]: Lua and speedtest1 by compilers/NAME (with the given environment), counted by callgrind.
set -u
C=$HOME/.cache/claude-2774
n=$1; shift
cd $C
env "$@" bin/buildlua.sh compilers/$n lua-$n > lua-$n.build.log 2>&1 || { echo "lua build failed"; exit 1; }
bin/luacount.sh lua-$n > lua-$n/luacount.log 2>&1
bin/moves.sh lua-$n > lua-$n/moves.txt 2>&1
env "$@" bin/st.sh compilers/$n st-$n > st-$n.log 2>&1
echo "== $n $*"; cat lua-$n/luacount.log | tr '\n' ' '; echo; head -1 lua-$n/moves.txt; tail -1 st-$n.log
