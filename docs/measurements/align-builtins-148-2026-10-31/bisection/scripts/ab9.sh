#!/usr/bin/env bash
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
stb=$HOME/buster-fast-bench/classify-148-claude/stb
for round in 1 2 3; do
    for tree in t978 talign8 talign9; do
        perf stat -x, -e instructions:u -o ab9-perf.csv taskset -c 2 ./$tree/build/compiler -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c -o ab9-$tree.o > /dev/null 2>&1
        echo "sqlite $round $tree status $? $(grep instructions ab9-perf.csv | cut -d, -f1)"
        perf stat -x, -e instructions:u -o ab9-perf.csv taskset -c 2 ./$tree/build/compiler -c -march=native -I$stb $stb/stb_image.c -o ab9-stb-$tree.o > /dev/null 2>&1
        echo "stb $round $tree status $? $(grep instructions ab9-perf.csv | cut -d, -f1)"
    done
done
