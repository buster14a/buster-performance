#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# #1398 step 5: the lexer unit by the split compilers with line tables, profiled by source line.
set -u
export EXCLUSIVE_OWNER=claude-1398
export EXCLUSIVE_TITLE="#1398 step 5 Tier 0: the self-built lexer by source line"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/1398"
lock=~/buster-fast-bench/exclusive.sh
root=~/buster-fast-bench/1398-claude-s5
X=$root/results/lines
mkdir -p "$X"
mapfile -t flags < "$root/results/flags.txt"
unit=c_lexer_benchmark
cd "$root/head"
for v in r m; do
    d=$root/lines-$v
    rm -rf "$d"; cp -r "$root/self-base" "$d"; rm -f "$d/compiler" "$d/$unit.o"
    "$lock" env BUSTER_S5_EXPERIMENT=$v "$root/compiler-exp" --lanes 1 "${flags[@]}" -gline-tables-only -c -o "$d/$unit.o" src/buster/compiler/$unit.c 2> "$X/$v-unit.err"
    echo "$v unit exit=$?" >> "$X/status.txt"
    clang -no-pie -o "$d/compiler" "$d"/*.o -lm -ldl -lpthread 2>> "$X/link.err"
    echo "$v link exit=$?" >> "$X/status.txt"
    "$lock" taskset -c 2 perf record -q -e instructions:u -c 100003 -o "$X/$v.data" "$d/compiler" benchmark-lexer src > "$X/$v-run.log" 2>&1
    echo "exit=$?" >> "$X/$v-run.log"
    perf report -i "$X/$v.data" --stdio --sort srcline -F sample,srcline --percent-limit 0.05 > "$X/$v-srcline.txt" 2>/dev/null
done
echo done > "$X/DONE"
