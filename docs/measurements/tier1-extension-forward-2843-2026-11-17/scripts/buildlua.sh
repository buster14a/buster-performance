#!/usr/bin/env bash
# buildlua.sh COMPILER DIR: Lua 5.4.8 by COMPILER --tier1 into DIR/lua-t1 (string-hash seed fixed, as #2767's record),
# with clang -O0's build as the reference (COMPILER "clang-O0").
set -u
C=$HOME/.cache/claude-2843; S=$C/S
B=$1; d=$2; mkdir -p $d
LUA=$S/inputs/lua-5.4.8/src
files=""; for f in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do files="$files $LUA/$f.c"; done
if [ "$B" = clang-O0 ]; then
    clang -O0 -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX '-Dluai_makeseed(L)=0x2592u' -o $d/lua-t1 $files -lm -ldl || exit 1
else
    $B --tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX '-Dluai_makeseed(L)=0x2592u' -o $d/lua-t1 $files -lm -ldl || exit 1
fi
