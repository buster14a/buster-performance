#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check
options=(--lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
for variant in base head-final; do
    taskset -c 2 "./$variant/build/compiler" "${options[@]}" -o "objects/sqlite-$variant.o"
    taskset -c 2 "./$variant/build/compiler" --time-stages "${options[@]}" -o objects/current.o 2> "logs/sqlite-$variant-stages.txt"
done
cmp objects/sqlite-base.o objects/sqlite-head-final.o
sha256sum objects/sqlite-base.o objects/sqlite-head-final.o
taskset -c 2 ./head-final/build/compiler time-runs --runs 15 --warmups 2 --copies 3 --directory "$PWD/copies" \
    --build base "$PWD/base/build/compiler" --build head "$PWD/head-final/build/compiler" \
    --list "${options[@]}" -o "$PWD/objects/current.o"
printf 'SQLITE_OK\n'
