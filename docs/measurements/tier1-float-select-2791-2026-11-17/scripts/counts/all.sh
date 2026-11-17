#!/usr/bin/env bash
# #2791's instruction counts: Lua's five scripts and speedtest1 by main's and the head's compilers, under callgrind.
set -u
cd "$(dirname "$0")"
C=$HOME/.cache/claude-2791
./buildlua.sh clang-O0 $C/counts/lua-o0 > lua-o0.log 2>&1
for s in calls tables strings arithmetic closures; do (cd $C/S/inputs && $C/counts/lua-o0/lua-t1 $s.lua > $C/S/ref/$s.out 2>&1); done
./buildlua.sh $C/main-compiler $C/counts/lua-main > lua-main.log 2>&1
./buildlua.sh $C/head-compiler-ef79 $C/counts/lua-head > lua-head.log 2>&1
./luacount.sh lua-main > lua-main.txt 2>&1
./luacount.sh lua-head > lua-head.txt 2>&1
./st.sh $C/main-compiler st-main > st-main.txt 2>&1
./st.sh $C/head-compiler-ef79 st-head > st-head.txt 2>&1
echo done > all.done
