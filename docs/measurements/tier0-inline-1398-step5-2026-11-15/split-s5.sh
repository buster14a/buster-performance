#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# #1398 step 5's split: the lexer unit (c_lexer_benchmark.c) self-built at Tier 0 by step 5 with only several returns
# spliced (r), only results in memory (m), and by base and head, each linked with base's other self-built units.
set -u
export EXCLUSIVE_OWNER=claude-1398
export EXCLUSIVE_TITLE="#1398 step 5 Tier 0: which shape costs the self-built lexer"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/1398"
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
lock=~/buster-fast-bench/exclusive.sh
root=~/buster-fast-bench/1398-claude-s5
X=$root/results/split
mkdir -p "$X"
progress() { echo "$(date -u +%FT%TZ) $*" >> "$X/progress.log"; }
git -C "$root/base" fetch -q "$root/exp.bundle" s5-exp:s5-exp && { test -d "$root/exp" || git -C "$root/base" worktree add -q --detach "$root/exp" s5-exp; }
git -C "$root/exp" checkout -q --detach s5-exp
(cd "$root/exp" && "$lock" ./build.sh --config Release > "$X/build-exp.log" 2>&1) || { progress "build exp failed"; exit 1; }
cp "$root/exp/build/compiler" "$root/compiler-exp"
progress "built exp $(git -C "$root/exp" rev-parse HEAD)"
mapfile -t flags < "$root/results/flags.txt"
unit=c_lexer_benchmark
for v in lexhead r m; do
    d=$root/split-$v
    rm -rf "$d"
    cp -r "$root/self-base" "$d"
    rm -f "$d/compiler" "$d/$unit.o"
done
cp "$root/self-head/$unit.o" "$root/split-lexhead/$unit.o"
cd "$root/head"
for v in r m; do
    "$lock" env BUSTER_S5_EXPERIMENT=$v "$root/compiler-exp" --lanes 1 "${flags[@]}" -c -o "$root/split-$v/$unit.o" src/buster/compiler/$unit.c 2> "$X/$v-unit.err"
    echo "$v unit exit=$?" >> "$X/status.txt"
done
for v in lexhead r m; do
    clang -no-pie -o "$root/split-$v/compiler" "$root/split-$v"/*.o -lm -ldl -lpthread 2>> "$X/link.err"
    echo "$v link exit=$?" >> "$X/status.txt"
done
for v in base head lexhead r m; do
    o=$root/self-$v/$unit.o
    [ -e "$root/split-$v/$unit.o" ] && o=$root/split-$v/$unit.o
    nm -S --size-sort "$o" | grep -E ' (tokenize_|scan_lines|write_chunk)' > "$X/$v-symbols.txt"
done
progress "built splits"
for round in 1 2; do
    for v in base head lexhead r m; do
        c=$root/self-$v/compiler
        [ -x "$root/split-$v/compiler" ] && c=$root/split-$v/compiler
        "$lock" taskset -c 2 "$c" benchmark-lexer src > "$X/$v-benchmark-lexer-$round.log" 2>&1
        echo "exit=$?" >> "$X/$v-benchmark-lexer-$round.log"
    done
done
progress "done"
echo done > "$X/DONE"
