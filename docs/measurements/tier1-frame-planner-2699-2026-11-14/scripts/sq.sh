#!/bin/bash
# usage: sq.sh COMPILER OUT [extra options]: --tier1 -c of the frozen sqlite3.c
c=$HOME/buster-fast-bench/2699-claude/corpus
comp=$1; out=$2; shift 2
exec "$comp" -c --tier1 "$@" --predefines "$c/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$c/headers/usr/lib/clang/23/include" -isystem "$c/headers/usr/local/include" -isystem "$c/headers/usr/include" -o "$out" "$c/sqlite/sqlite3.c"
