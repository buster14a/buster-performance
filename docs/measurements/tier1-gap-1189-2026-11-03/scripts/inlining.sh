#!/usr/bin/env bash
# inlining.sh SQLITE SPEEDTEST LUA OUT: clang -O2's speedtest1 and Lua, built as the record's corpora.sh builds them
# but with -Rpass=inline, into OUT. SQLITE holds the frozen sqlite3.c, SPEEDTEST speedtest1.c, LUA Lua 5.4.8's src/.
# The remarks don't change the code: both executables' SHA-256s must be main-96b6cbcd/inputs.sha256's, the measured
# ones'. Each remark "'CALLEE' inlined into 'CALLER'" becomes a "CALLEE<TAB>CALLER" line of OUT/inlined-st.tsv and
# OUT/inlined-lua.tsv, sorted, which are compared with the record's. A hash or a comparison that differs makes the exit
# status 1.
set -eu
R=$(cd "$(dirname "$0")/.." && pwd)
M=$R/main-96b6cbcd
Q=$(readlink -f "$1")
SRC=$(readlink -f "$2")
LUA=$(readlink -f "$3")
mkdir -p "$4"
O=$(readlink -f "$4")
cd "$O"
unset CPATH C_INCLUDE_PATH
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
clang -O2 -c $FLAGS -I"$Q" -Rpass=inline -o clang2-sqlite3.o "$Q/sqlite3.c" 2> sqlite3.remarks
clang -O2 -c $FLAGS -I"$Q" -Rpass=inline -o clang2-speedtest1.o "$SRC/speedtest1.c" 2> speedtest1.remarks
cc -o st-clang2 clang2-speedtest1.o clang2-sqlite3.o -lm
lua_files=""
for f in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do
    lua_files="$lua_files $LUA/$f.c"
done
clang -O2 -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -Rpass=inline -o lua-clang2 $lua_files -lm -ldl 2> lua.remarks
status=0
grep -E " (st|lua)-clang2$" "$M/inputs.sha256" | sha256sum -c || { echo "inlining.sh: a build differs from the measured one; its remarks don't describe it"; status=1; }
pairs() { sed -n "s/.*remark: '\([^']*\)' inlined into '\([^']*\)'.*/\1\t\2/p" "$@" | LC_ALL=C sort; }
pairs sqlite3.remarks speedtest1.remarks > inlined-st.tsv
pairs lua.remarks > inlined-lua.tsv
for f in inlined-st.tsv inlined-lua.tsv; do
    if cmp -s $f "$M/$f"; then
        echo "$f: the record's"
    else
        echo "$f: DIFFERS from the record's"
        status=1
    fi
done
exit $status
