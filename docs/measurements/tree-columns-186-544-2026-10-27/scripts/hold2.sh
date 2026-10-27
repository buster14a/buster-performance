#!/bin/bash
base=~/buster-fast-bench/tree-186-544-claude
out=$base/parser3
mkdir -p $out
exe=$base/head3/build/compiler
SQLITE=~/buster-fast-bench/refine-claude/inputs/sqlite3.c
LIBC="$(cat ~/buster-fast-bench/parser-claude/inputs/libc.txt | tr '\n' ' ')"
MAINC="-march=native -I$base/main/src -fwrapv -funsigned-char --predefines $base/parser1/predefines.h $base/main/src/buster/compiler/main.c"
taskset -c 2 $exe benchmark-parser --only stages $SQLITE > "$out/sqlite3-head3.txt" 2>&1
taskset -c 2 $exe benchmark-parser --only stages $LIBC > "$out/libc-head3.txt" 2>&1
taskset -c 2 $exe benchmark-parser --only stages $MAINC > "$out/mainc-head3.txt" 2>&1
