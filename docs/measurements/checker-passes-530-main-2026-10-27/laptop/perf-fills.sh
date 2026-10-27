#!/bin/bash
S=/home/david/buster-lab/inputs/sqlite-amalgamation-3530400
for i in 1 2 3 4; do
  for c in "$@"; do
    env -u CPATH -u C_INCLUDE_PATH perf record -q -e cpu/event=0x43,umask=0x48/u -c 1009 -o perf-fills-$c-$i.data -- ./$c -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$S $S/sqlite3.c -o /dev/null 2>/dev/null
  done
done
