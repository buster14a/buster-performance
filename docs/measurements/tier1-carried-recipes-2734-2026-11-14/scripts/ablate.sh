#!/usr/bin/env bash
# ablate.sh: callgrind counts of Lua's five scripts and speedtest1 for main, head and head without each rule.
cd ~/.cache/claude-2592
log=abl/summary.txt; : > $log
run() { # name compiler [ENV=1]
  local name=$1 compiler=$2; shift 2
  ( export "$@" 2>/dev/null; bin/st.sh $PWD/$compiler abl/st-$name > abl/st-$name.log 2>&1 ) &
  ( export "$@" 2>/dev/null; bin/buildlua.sh $PWD/$compiler abl/lua-$name > abl/lua-$name.build 2>&1 && bin/luacount.sh abl/lua-$name > abl/lua-$name.log 2>&1 )
  wait
  echo "$name st $(tail -1 abl/st-$name.log) | lua $(tail -1 abl/lua-$name.log) | $(grep -c same abl/lua-$name/check.txt) same" >> $log
}
run main compilers-main3 X=1
run head compilers-h6 X=1
run noproof compilers-abl BUSTER_TMP_NO_PROOF=1
run noalt compilers-abl BUSTER_TMP_NO_ALT=1
run notie compilers-abl BUSTER_TMP_NO_TIE=1
run noshift compilers-abl BUSTER_TMP_NO_SHIFT=1
echo done >> $log
