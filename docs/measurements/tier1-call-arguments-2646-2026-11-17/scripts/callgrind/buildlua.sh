#!/usr/bin/env bash
# buildlua.sh COMPILER DIR [options]: Lua 5.4.8 by COMPILER --tier1 (its string-hash seed fixed) into DIR/lua-t1.
set -u
S=$HOME/.cache/claude-2646/cg/S
B=$1; d=$2; shift 2
LUA=$S/inputs/lua-5.4.8/src
mkdir -p $d
files=""; for f in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do files="$files $LUA/$f.c"; done
$B --tier1 -fno-asynchronous-unwind-tables "$@" -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX '-Dluai_makeseed(L)=0x2592u' -o $d/lua-t1 $files -lm -ldl || exit 1
