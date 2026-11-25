#!/bin/bash
# measure-instr.sh NAME...: the 9700X job's "Hold sqlite3.c's compile to its instructions' baseline" step with
# trees/NAME's compiler and its own tools/ci/compile-instructions.txt.
set -uo pipefail
here=$HOME/buster-fast-bench/3581-claude-hape45
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
for n in "$@"; do
    cd "$here/trees/$n"
    echo "== $n"
    taskset -c 2 ./build/compiler measure-compile --runs 3 --instructions-baseline tools/ci/compile-instructions.txt -- \
        -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /dev/shm/hape45-mi.o 2>&1 | tail -6
done
rm -f /dev/shm/hape45-mi.o
