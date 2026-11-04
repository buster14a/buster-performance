#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# test-lexer's wall time of each build, three runs each, on CPU 2 under the lock per run (bash's clock: no bc here).
export EXCLUSIVE_OWNER=claude-1282 EXCLUSIVE_TITLE="#1282 IR: inline SIMD intrinsic wrappers (9700X record)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/1324"
lock=~/buster-fast-bench/exclusive.sh
cd ~/buster-fast-bench/1282-claude/repo
out=../results
: > $out/test-lexer.tsv
for run in 1 2 3; do
    for name in clang tier0 tier1-noinline tier1; do
        compiler=$out/$name/compiler
        [ $name = clang ] && compiler=./build/compiler
        "$lock" bash -c 's=$EPOCHREALTIME; taskset -c 2 "$1" test-lexer > /dev/null 2>&1; c=$?; e=$EPOCHREALTIME; printf "%s\t%s\t%s\texit=%s\n" "$2" "$3" "$(awk -v s=$s -v e=$e "BEGIN { printf \"%.3f\", e - s }")" "$c"' _ "$compiler" "$name" "$run" >> $out/test-lexer.tsv
    done
done
echo done >> $out/test-lexer.tsv
