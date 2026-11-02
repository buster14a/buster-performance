#!/usr/bin/env bash
# identity2.sh BASE HEAD: --tier1 -c of the frozen sqlite3.c by both paths and of Lua 5.4.8's 34 sources, by each tree,
# each tree's compiles one hold of the shared lock: each object must be the same bytes at HEAD as at BASE.
. ~/buster-fast-bench/claude-141-remaining/common.sh
out=$PWD/identity-$2
mkdir -p $out
lua_names="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
for t in $1 $2; do
    mkdir -p $out/$t
    "$lock" bash -c "for p in vector scalar; do s=\$([ \$p = scalar ] && echo --scalar); $PWD/$t/build/compiler --tier1 \$s -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $out/$t/sqlite3-\$p.o $Q/sqlite3.c; done; for f in $lua_names; do $PWD/$t/build/compiler --tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o $out/$t/\$f.o $LUA/\$f.c; done"
done
same=0
differ=0
for o in $out/$1/*.o; do
    n=$(basename $o)
    if cmp -s $o $out/$2/$n; then same=$((same + 1)); else differ=$((differ + 1)); echo "differs: $n"; fi
done
echo "identity $1 $2: $same objects identical, $differ differ"
