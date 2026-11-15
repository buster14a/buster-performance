#!/bin/bash
# prof.sh COMPILER LABEL N EXTRA...: perf record of N sqlite3.c compiles, CPU 2, a different period each (deterministic-compile trap).
set -u
X=$1; L=$2; N=$3; shift 3
cd ~/buster-fast-bench/1360-claude
mkdir -p prof out
SQOPTS="-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
for ((i = 0; i < N; i++)); do
  perf record -q -e cycles:u -c $((200003 + 2 * i)) -o prof/$L-$i.data taskset -c 2 $X $SQOPTS "$@" inputs/sqlite3.c -o out/prof-$L.o > /dev/null 2>&1
done
