#!/bin/bash
# bench-parser.sh OUT: benchmark-parser --only stages (21 passes) of sqlite3.c, the libc corpus and main.c, by main's
# build and head's, in turn, each run under the lock by itself, pinned to CPU 2.
base=~/buster-fast-bench/tree-186-544-claude
out=$base/$1
mkdir -p "$out"
SQLITE=~/buster-fast-bench/refine-claude/inputs/sqlite3.c
LIBC="$(cat ~/buster-fast-bench/parser-claude/inputs/libc.txt | tr '\n' ' ')"
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > "$out/predefines.h"
MAINC="-march=native -I$base/main/src -fwrapv -funsigned-char --predefines $out/predefines.h $base/main/src/buster/compiler/main.c"
for round in 1 2; do
    for tree in main head; do
        exe=$base/$tree/build/compiler
        $base/lock.sh taskset -c 2 $exe benchmark-parser --only stages $SQLITE > "$out/sqlite3-$tree-$round.txt" 2>&1
        $base/lock.sh taskset -c 2 $exe benchmark-parser --only stages $LIBC > "$out/libc-$tree-$round.txt" 2>&1
        $base/lock.sh taskset -c 2 $exe benchmark-parser --only stages $MAINC > "$out/mainc-$tree-$round.txt" 2>&1
    done
done
echo done > "$out/done"
