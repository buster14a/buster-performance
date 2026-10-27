#!/bin/bash
base=~/buster-fast-bench/tree-186-544-claude
cd $base && rm -rf main-g && cp -r main main-g && rm -rf main-g/build
(cd main-g && ./build.sh > build.log 2>&1)
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
exe=$base/main-g/build/compiler
perf record -F 20000 -o $base/walk.data -- bash -c "for i in 1 2 3 4 5; do taskset -c 2 $exe -c --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c -o /dev/null; done" > $base/perf-record.log 2>&1
