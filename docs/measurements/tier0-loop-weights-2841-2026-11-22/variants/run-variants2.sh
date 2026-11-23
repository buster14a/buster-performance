#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# #2841 variants, round 2: run-variants.sh's compiler and programs. The tree's own sources self-built at Tier 0 by
# base (X2841_SHIFT=0) and s1 (=1), then benchmark-lexer, benchmark-refinement and benchmark-files by each, twice;
# then Lua and speedtest1 by base, head and s1 again, two rounds.
set -u
export EXCLUSIVE_OWNER=claude-2841-variants
export EXCLUSIVE_TITLE="PR 3322 merge-ready (Tier 0 loop-weighted homes, #2841): variants round 2"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/3322"
lock=~/buster-fast-bench/exclusive.sh
root=~/buster-fast-bench/2841-claude-variants
old=~/buster-fast-bench/2841-claude
out=$root/results2
W=$root/programs
mkdir -p "$out"
progress() { echo "$(date -u +%FT%TZ) $*" >> "$out/progress.log"; }
C=$root/compiler
cd "$root/tree" || exit 1
flags=()
mapfile -d '' all < <(BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags --config Release)
for f in "${all[@]}"; do case "$f" in -O3|-Wall|-Werror|-g) ;; *) flags+=("$f") ;; esac; done
printf '%s\n' "${flags[@]}" > "$out/flags.txt"
mapfile -d '' sources < <(./build.sh print-sources)
for v in base:0 s1:1; do
    IFS=: read -r name shift <<< "$v"
    rm -rf "${root:?}/self-$name"; mkdir -p "$root/self-$name"
    X2841_SHIFT=$shift X2841_CALLEE=0 "$lock" bash -c 'times=$1; compiler=$2; directory=$3; n=$4; shift 4; flags=("${@:1:$n}"); shift $n; objects=(); for s in "$@"; do start=$EPOCHREALTIME; "$compiler" --lanes 1 "${flags[@]}" -c -o "$directory/$(basename "$s" .c).o" "$s"; status=$?; echo "$start $EPOCHREALTIME $status $s" >> "$times"; [ $status -eq 0 ] || exit 1; objects+=("$directory/$(basename "$s" .c).o"); done; clang -no-pie -o "$directory/compiler" "${objects[@]}" -lm -ldl -lpthread' _ "$out/$name-unit-times.txt" "$C" "$root/self-$name" "${#flags[@]}" "${flags[@]}" "${sources[@]}" 2>> "$out/$name-units.err" || progress "selfhost $name failed"
    progress "selfhost $name built"
done
clang -dM -E -march=znver5 -fwrapv -funsigned-char -x c /dev/null > "$root/predefines.h"
for round in 1 2; do
    for name in base s1; do
        c="$root/self-$name/compiler"
        test -x "$c" || continue
        "$lock" bash -c 'c=$1; D=$2; v=$3; round=$4; predefines=$5
            taskset -c 2 "$c" benchmark-lexer src > "$D/$v-benchmark-lexer-$round.log" 2>&1; echo "exit=$?" >> "$D/$v-benchmark-lexer-$round.log"
            taskset -c 2 "$c" benchmark-refinement --only refine_tokens_fused src > "$D/$v-benchmark-refinement-$round.log" 2>&1; echo "exit=$?" >> "$D/$v-benchmark-refinement-$round.log"
            taskset -c 2 "$c" benchmark-files --lanes 1 --cpus 2 --runs 7 -march=znver5 -Isrc -fwrapv -funsigned-char --predefines "$predefines" src/buster/compiler/main.c > "$D/$v-benchmark-files-$round.log" 2>&1; echo "exit=$?" >> "$D/$v-benchmark-files-$round.log"' _ "$c" "$out" "$name" "$round" "$root/predefines.h" 2> "$out/$name-hold-$round.err"
    done
    progress "selfhost round $round done"
done
scripts=$old/inputs/performance/docs/measurements/tier1-reciprocal-141-2026-11-01/9700x/lua
builds=(--build base "$W/lua-base" --build head "$W/lua-head" --build s1 "$W/lua-s1")
for round in 1 2; do
    "$lock" taskset -c 2 "$C" time-runs --runs 5 --build base "$W/speedtest1-base" --build head "$W/speedtest1-head" --build s1 "$W/speedtest1-s1" --list --memdb --shrink-memory --reprepare --size 5 --heap 40000000 64 --testset mix1 > "$out/speedtest1-$round.log" 2>&1
    echo "exit=$?" >> "$out/speedtest1-$round.log"
    for s in calls closures strings tables arithmetic; do
        "$lock" taskset -c 2 "$C" time-runs --runs 9 "${builds[@]}" --list "$scripts/$s.lua" > "$out/lua-$s-$round.log" 2>&1
        echo "exit=$?" >> "$out/lua-$s-$round.log"
    done
    progress "programs round $round done"
done
progress "all done"
echo done > "$out/DONE"
