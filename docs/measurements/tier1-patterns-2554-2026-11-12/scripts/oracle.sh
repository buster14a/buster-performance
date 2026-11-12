#!/bin/bash
# oracle.sh: Lua by clang -O2 (its 33 sources, one command), whose outputs of the five scripts every build's must equal
# (runs.sh's checks); and the scripts' expected outputs. Run inside one hold of the lock.
set -eu
cd "$(dirname "$0")"
mkdir -p scratch/oracle results
unset CPATH C_INCLUDE_PATH
head -1 /var/lib/buster-9700x/owner >> results/holders.txt
sources=()
for s in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do
    sources+=("$PWD/inputs/lua-5.4.8/src/$s.c")
done
clang --version | head -1 > results/oracle.txt
clang -O2 -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o scratch/oracle/lua-clang2 "${sources[@]}" -lm -ldl
for s in calls tables strings arithmetic closures; do
    (cd inputs/scripts && "$OLDPWD/scratch/oracle/lua-clang2" "$s.lua") > "scratch/oracle/$s.expected" 2>&1
done
sha256sum scratch/oracle/* >> results/oracle.txt
