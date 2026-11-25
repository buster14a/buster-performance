#!/bin/bash
# run.sh NAME [harness args...]: bin/direct-NAME(.native) on the frozen sqlite3.c as compile-count compiles it.
name=$1; shift
C=/home/user/corpus
bin=/home/user/dp/bin/direct-$name
[ -x "$bin.native" ] && bin=$bin.native
exec "$bin" --predefines "$C/provenance/gnu17-pinned-predefines.txt" -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include" \
   -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c" "$@"
