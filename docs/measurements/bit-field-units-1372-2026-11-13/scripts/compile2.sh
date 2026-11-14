#!/bin/bash
# #1372's compile-time comparison of base and head2, run under one hold of the 9700X's lock: the frozen sqlite3.c's -c
# (with #133's record's SQLite defines) and the 32,768-access stress (gen_fields.c), by time-runs, 21 runs each, on CPU 2.
set -euo pipefail
cd ~/buster-fast-bench/1372-claude
corpus=~/buster-fast-bench/corpus-391e729af658
sqlite=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$corpus/sqlite")
taskset -c 2 head2/build/compiler time-runs --runs 21 --warmups 2 --build base base/build/compiler --build head2 head2/build/compiler \
    --list -c "${sqlite[@]}" "$corpus/sqlite/sqlite3.c" -o /tmp/1372-claude-sqlite.o > out/time2-sqlite-c.txt 2>&1
taskset -c 2 head2/build/compiler time-runs --runs 21 --warmups 2 --build base base/build/compiler --build head2 head2/build/compiler \
    --list -c "${sqlite[@]}" --tier1 "$corpus/sqlite/sqlite3.c" -o /tmp/1372-claude-sqlite1.o > out/time2-sqlite-tier1.txt 2>&1
taskset -c 2 head2/build/compiler time-runs --runs 21 --warmups 2 --build base base/build/compiler --build head2 head2/build/compiler \
    --list -c out/fields.c -o /tmp/1372-claude-fields.o > out/time2-fields-c.txt 2>&1
sha256sum head2/build/compiler out/k-head2-tier0.o out/k-head2-tier1.o >> out/identities.sha256
echo compiled2
