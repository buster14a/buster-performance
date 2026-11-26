#!/usr/bin/env bash
# #2553 validation glue: the pinned historical workload flags, with one emission lane.
set -euo pipefail
compiler=$(realpath "$1")
mkdir -p "$2"
out=$(realpath "$2")
task=$(cd -- "$(dirname -- "$0")/.." && pwd)
inputs=${INPUTS:-$task/inputs-2553}
export LC_ALL=C
export BUSTER_CLANG_RESOURCE_DIR=${BUSTER_CLANG_RESOURCE_DIR:-/home/agent/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/lib/clang/23}
sha256sum "$compiler" > "$out/compiler.sha256"
common=(--tier1 --lanes 1 -fno-asynchronous-unwind-tables --tier1-report)
sqlite=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE)
lua=(-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX '-Dluai_makeseed(L)=0x2768u')
sources=()
for name in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do
    sources+=("$inputs/lua-5.4.8/src/$name.c")
done
cd "$out"
rm -f speedtest1.kinds lua.kinds
printf '%q ' "$compiler" "${common[@]}" "${sqlite[@]}" "-I$inputs/corpus/sqlite" -o "$out/speedtest1" "$inputs/speedtest1-unity.c" -lm > commands.txt
printf '\n' >> commands.txt
printf '%q ' "$compiler" "${common[@]}" "${lua[@]}" -o "$out/lua" "${sources[@]}" -lm -ldl >> commands.txt
printf '\n' >> commands.txt
BUSTER_TIER1_KINDS="$out/speedtest1.kinds" "$compiler" "${common[@]}" "${sqlite[@]}" "-I$inputs/corpus/sqlite" -o "$out/speedtest1" "$inputs/speedtest1-unity.c" -lm > sqlite-build.log 2>&1
BUSTER_TIER1_KINDS="$out/lua.kinds" "$compiler" "${common[@]}" "${lua[@]}" -o "$out/lua" "${sources[@]}" -lm -ldl > lua-build.log 2>&1
sha256sum speedtest1 lua > programs.sha256
