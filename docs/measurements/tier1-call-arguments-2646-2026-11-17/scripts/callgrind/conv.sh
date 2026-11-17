#!/usr/bin/env bash
# conv.sh NAME...: callgrind counts (Lua's five scripts and speedtest1) for compilers-NAME, into conv/.
cd ~/.cache/claude-2646/cg
for c in "$@"; do
  ( bin/st.sh $PWD/compilers-$c conv/st-$c > conv/st-$c.log 2>&1 ) &
  ( bin/buildlua.sh $PWD/compilers-$c conv/lua-$c > conv/lua-$c-build.log 2>&1 && bin/luacount.sh conv/lua-$c > conv/lua-$c.log 2>&1 )
  wait
  echo "$c st $(tail -1 conv/st-$c.log) | lua $(tail -1 conv/lua-$c.log) | $(grep -c same conv/lua-$c/check.txt) same" >> conv/summary.txt
done
