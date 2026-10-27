#!/bin/bash
# Interleaved --time-stages runs of each executable, with check-declarations.
S=/home/david/buster-lab/inputs/sqlite-amalgamation-3530400
for round in $(seq 1 15); do
  for c in "$@"; do
    env -u CPATH -u C_INCLUDE_PATH taskset -c ${CORES_CPU:-$(cut -d, -f1 <<<"$(taskset -pc $$ | sed 's/.*: //')" | cut -d- -f1)} ./$c --time-stages -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$S $S/sqlite3.c -o /dev/null 2>&1 | awk -v c=$c '$1=="time-stage" {print c, $2, $3}'
  done
done
