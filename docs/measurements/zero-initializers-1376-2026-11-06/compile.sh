#!/bin/bash
# sqlite3.c's -c by base and head as whole processes, under the lock (time-runs rotates their order).
set -euo pipefail
cd ~/buster-fast-bench/1376-opencode
out=results/compile-$(date +%s)
mkdir -p "$out"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
taskset -c 2 head/build/compiler time-runs --runs 21 --warmups 2 --build base base/build/compiler --build head head/build/compiler \
    --list -c --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/1376-opencode-sqlite.o \
    > "$out/time-runs.txt" 2>&1
for t in base head; do $t/build/compiler -c --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o "$out/sqlite-$t.o"; done
sha256sum "$out"/*.o > "$out/sha256.txt"
echo "$out"
