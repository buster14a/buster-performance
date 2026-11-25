#!/bin/bash
# mc.sh NAME...: each bin/compiler-NAME's measure-compile of the frozen sqlite3.c against trees/main's instructions'
# baseline, as the 9700X job's last step runs it, in turn twice.
set -uo pipefail
here=$HOME/buster-fast-bench/3584-direct-s6acj8
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
for round in 1 2; do
  for n in "$@"; do
    echo "== $n round $round"
    (cd /dev/shm && taskset -c 2 "$here/bin/compiler-$n" measure-compile --runs 3 --instructions-baseline "$here/trees/main/tools/ci/compile-instructions.txt" -- \
      -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" 2>&1 | tail -6)
  done
done
