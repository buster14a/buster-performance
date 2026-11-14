#!/usr/bin/env bash
# buildlua.sh COMPILER DIR [options]: Lua 5.4.8 by COMPILER --tier1 into DIR/lua-t1, and lvm.o's luaV_execute into DIR/exec.dis.
set -u
S=$HOME/.cache/claude-2592/S
B=$1; d=$2; shift 2
LUA=$S/inputs/lua-5.4.8/src
mkdir -p $d
files=""; for f in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do files="$files $LUA/$f.c"; done
$B --tier1 -fno-asynchronous-unwind-tables "$@" -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o $d/lua-t1 $files -lm -ldl || exit 1
$B --tier1 -fno-asynchronous-unwind-tables "$@" -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o $d/lvm.o $LUA/lvm.c || exit 1
objdump -dr --no-show-raw-insn $d/lvm.o | awk '/<luaV_execute>:/,/^$/' > $d/exec.dis
echo "luaV_execute: $(grep -c '^ *[0-9a-f]*:' $d/exec.dis) instructions"
