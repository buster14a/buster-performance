#!/bin/bash
S=/home/david/buster-lab/inputs/sqlite-amalgamation-3530400
for c in "$@"; do
  for i in $(seq 1 8); do
    env -u CPATH -u C_INCLUDE_PATH perf record -q -e cycles:u -c 100003 -o perf-decl-$c-$i.data ./$c -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$S $S/sqlite3.c -o /dev/null 2>/dev/null
  done
done
