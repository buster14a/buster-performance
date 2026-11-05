#!/bin/bash
tree="$1"; out="$2"
mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-1038 EXCLUSIVE_TITLE="GitHub issue #1038" EXCLUSIVE_LINK=https://claude.ai/code/session_01TiDLnvzc6A3cz2qD5dSRLw
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
cd "$tree"
for r in 1 2 3; do
BUSTER_DBG_VISITS=1 ~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler "${options[@]}" -o "$out/sqlite3.o" --time-stages 2> "$out/dbg-$r.txt"
done
echo done > "$out/done-dbg"
