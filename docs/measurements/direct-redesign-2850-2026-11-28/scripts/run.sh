#!/bin/bash
# run.sh NAME [harness arguments]: bin/direct-NAME.native on the frozen sqlite3.c, where it was built. C is the
# frozen corpus (tools/ci/fetch-corpus.sh), W the directory of mk.sh's bin/ and of features.txt.
W=${W:-$(cd "$(dirname "$0")" && pwd)}
C=${C:?the frozen corpus directory}
n=$1; shift
FEATURES=${FEATURES:-$W/features.txt} exec "$W/bin/direct-$n.native" --predefines "$C/provenance/gnu17-pinned-predefines.txt" -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c" "$@"
