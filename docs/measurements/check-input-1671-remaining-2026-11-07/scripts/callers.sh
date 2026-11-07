#!/bin/bash
# usage: callers.sh LABEL SYMBOL: one perf record with DWARF call graphs of out-LABEL/compiler on -c sqlite3.c, under the
# lock, then SYMBOL's callers (#1671).
set -u
base=~/buster-fast-bench/1671-claude-coded
out="$base/out-$1"
export EXCLUSIVE_OWNER=claude-1671-coded EXCLUSIVE_TITLE="#1671: the reader's remaining time" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1671
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
~/buster-fast-bench/exclusive.sh taskset -c 2 perf record -q -F 5000 --call-graph dwarf,16384 -o "$out/perf-g.data" -- "$out/compiler" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o "$out/g.o"
perf report -i "$out/perf-g.data" --stdio --no-children -S "$2" -G --percent-limit 0.5 2>/dev/null | grep -v "^$" | head -60
