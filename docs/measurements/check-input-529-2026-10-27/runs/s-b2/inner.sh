#!/bin/bash
set -e
a=$1; b=$2; out=$3
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
taskset -c 2 "$a" measure-compile --runs 11 --directory "$out" --reference "$b" -- "${options[@]}" > "$out/measure-A.txt" 2>&1
taskset -c 2 "$b" measure-compile --runs 11 --directory "$out" --reference "$a" -- "${options[@]}" > "$out/measure-B.txt" 2>&1
