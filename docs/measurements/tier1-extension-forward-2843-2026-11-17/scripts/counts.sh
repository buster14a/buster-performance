#!/usr/bin/env bash
# counts.sh: Lua's five scripts and speedtest1 by main's and head's --tier1, each checked, then counted under callgrind.
set -u
C=$HOME/.cache/claude-2843; X=$C/scripts; O=$C/counts
mkdir -p $O
# clang -O0's Lua outputs are the reference.
$X/buildlua.sh clang-O0 $O/lua-clang || exit 1
for s in calls tables strings arithmetic closures; do (cd $C/S/inputs && $O/lua-clang/lua-t1 $s.lua > $C/S/ref/$s.out 2>&1); done
for side in main head; do
    $X/buildlua.sh $C/compiler-$side $O/lua-$side || exit 1
    sha256sum $O/lua-$side/lua-t1
    $X/luacount.sh $O/lua-$side
    $X/st.sh $C/compiler-$side $O/st-$side
    sha256sum $O/st-$side/st
done
