#!/usr/bin/env bash
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c)
for round in 1 2 3; do
    for tree in t978 tcat talign10; do
        perf stat -x, -e instructions:u -o ab13-perf.csv taskset -c 2 ./$tree/build/compiler -fsyntax-only "${options[@]}" > /dev/null 2>&1
        echo "syntax $round $tree status $? $(grep instructions ab13-perf.csv | cut -d, -f1)"
    done
done
