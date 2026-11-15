#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# #1398 step 5: where the self-built lexer's extra instructions are, by symbol and by address, base against head.
set -u
export EXCLUSIVE_OWNER=claude-1398
export EXCLUSIVE_TITLE="#1398 step 5 Tier 0: profile of the self-built lexer"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/1398"
lock=~/buster-fast-bench/exclusive.sh
root=~/buster-fast-bench/1398-claude-s5
P=$root/results/perf
mkdir -p "$P"
cd "$root/head"
for v in base head; do
    "$lock" taskset -c 2 perf record -q -e instructions:u -c 1000003 -o "$P/$v-instructions.data" "$root/self-$v/compiler" benchmark-lexer src > "$P/$v-run.log" 2>&1
    echo "exit=$?" >> "$P/$v-run.log"
    perf report -i "$P/$v-instructions.data" --stdio --sort sym --percent-limit 0.2 > "$P/$v-instructions-by-symbol.txt" 2>/dev/null
    perf report -i "$P/$v-instructions.data" --stdio --sort sym --percent-limit 0.2 -F overhead,sample,sym > "$P/$v-samples-by-symbol.txt" 2>/dev/null
done
echo done > "$P/DONE"
