#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# #2841 variants: one experiment compiler (buster c9d66c22 + x2841.patch, never part of a PR) whose environment picks
# the loop factor (X2841_SHIFT: 0 = main's unweighted homes, 3 = the PR's 8x, 1 = 2x) and X2841_CALLEE=1 (a local
# referenced once counts 1 wherever it is). Lua 5.4.8 and speedtest1 built by each at Tier 0, timed by time-runs,
# two rounds, one lock hold per round of a program, on CPU 2.
set -u
export EXCLUSIVE_OWNER=claude-2841-variants
export EXCLUSIVE_TITLE="PR 3322 merge-ready (Tier 0 loop-weighted homes, #2841): variants"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/3322"
lock=~/buster-fast-bench/exclusive.sh
root=~/buster-fast-bench/2841-claude-variants
old=~/buster-fast-bench/2841-claude
out=$root/results
W=$root/programs
mkdir -p "$out" "$W"
progress() { echo "$(date -u +%FT%TZ) $*" >> "$out/progress.log"; }
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
(cd "$root/tree" && "$lock" ./build.sh --config Release > "$out/build.log" 2>&1) || { progress "build failed"; exit 1; }
cp "$root/tree/build/compiler" "$root/compiler"
progress "built $(git -C "$root/tree" rev-parse HEAD) + x2841.patch"
I=$old/inputs
S=$old/corpus/sqlite
lua=()
for s in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do lua+=("$I/lua-5.4.8/src/$s.c"); done
variants="base:0:0 head:3:0 s1:1:0 once1:1:1"
"$lock" bash -c 'C=$1; W=$2; S=$3; I=$4; U=$5; variants=$6; shift 6
    for v in $variants; do IFS=: read -r name shift callee <<< "$v"
        X2841_SHIFT=$shift X2841_CALLEE=$callee "$C" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$S" -I"$I" -o "$W/speedtest1-$name" "$U" -lm || exit 1
        X2841_SHIFT=$shift X2841_CALLEE=$callee "$C" -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o "$W/lua-$name" "$@" -lm -ldl || exit 1
    done' _ "$root/compiler" "$W" "$S" "$I" "$old/programs/speedtest1-unity.c" "$variants" "${lua[@]}" > "$out/builds.log" 2>&1 || { progress "program builds failed"; exit 1; }
sha256sum "$W"/* > "$out/hashes.txt"
cmp "$W/lua-base" "$old/programs/lua-base" > "$out/same-as-record.txt" 2>&1; cmp "$W/lua-head" "$old/programs/lua-head" >> "$out/same-as-record.txt" 2>&1
progress "programs built"
scripts=$I/performance/docs/measurements/tier1-reciprocal-141-2026-11-01/9700x/lua
builds=(--build base "$W/lua-base" --build head "$W/lua-head" --build s1 "$W/lua-s1" --build once1 "$W/lua-once1")
for round in 1 2; do
    "$lock" taskset -c 2 "$root/compiler" time-runs --runs 5 --build base "$W/speedtest1-base" --build head "$W/speedtest1-head" --build s1 "$W/speedtest1-s1" --build once1 "$W/speedtest1-once1" --list --memdb --shrink-memory --reprepare --size 5 --heap 40000000 64 --testset mix1 > "$out/speedtest1-$round.log" 2>&1
    echo "exit=$?" >> "$out/speedtest1-$round.log"
    for s in calls closures strings tables arithmetic; do
        (cd "$scripts" && "$lock" taskset -c 2 "$root/compiler" time-runs --runs 5 "${builds[@]}" --list "$scripts/$s.lua") > "$out/lua-$s-$round.log" 2>&1
        echo "exit=$?" >> "$out/lua-$s-$round.log"
    done
    progress "round $round done"
done
progress "all done"
echo done > "$out/DONE"
