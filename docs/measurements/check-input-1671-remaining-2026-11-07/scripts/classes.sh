#!/bin/bash
# usage: classes.sh LABEL: benchmark-checker-bindings of out-LABEL/compiler on the frozen sqlite3.c, CPU 2, under the
# lock: the expressions' walk by class and #1038's numbering by passes, on the 9700X (#1671).
set -u
base=~/buster-fast-bench/1671-claude-coded
out="$base/out-$1"
export EXCLUSIVE_OWNER=claude-1671-coded EXCLUSIVE_TITLE="#1671: the reader's remaining time" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1671
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
~/buster-fast-bench/exclusive.sh taskset -c 2 "$out/compiler" benchmark-checker-bindings --passes 9 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" > "$out/classes.txt" 2>&1
grep -E "^expression|^check_input: mode=direct" "$out/classes.txt"
