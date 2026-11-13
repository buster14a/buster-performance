#!/usr/bin/env bash
# records.sh COMPILER NAME: --tier1 --tier1-report of the frozen sqlite3.c (#1190's flags) and of Lua 5.4.8's 33 sources
# (its Makefile's flags), each -c, into rep/; prints the summed fields that change.
set -eu
R=/root/.cache/claude-2602; C=$1; t=$2
FILES="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
unset CPATH C_INCLUDE_PATH
mkdir -p $R/rep/lua-$t
$C --tier1 --tier1-report -fno-asynchronous-unwind-tables -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -c -o $R/rep/sq-$t.o $R/sqlite/sqlite3.c 2> $R/rep/sq-$t.report
: > $R/rep/lua-$t.report
for f in $FILES; do
    $C --tier1 --tier1-report -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o $R/rep/lua-$t/$f.o $R/inputs/lua-5.4.8/src/$f.c 2>> $R/rep/lua-$t.report
done
for w in sq lua; do
    awk -v w=$w -v t=$t '{for (i = 2; i <= NF; i++) { split($i, kv, "="); s[kv[1]] += kv[2]; if (!(kv[1] in o)) { o[kv[1]] = i; n[i] = kv[1] } } } END { printf "%s %s", w, t; for (i = 2; i in n; i++) printf " %s=%d", n[i], s[n[i]]; printf "\n" }' $R/rep/$w-$t.report
done
