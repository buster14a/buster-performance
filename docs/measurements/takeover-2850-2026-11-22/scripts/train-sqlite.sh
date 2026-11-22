#!/bin/bash
# BUSTER_PGO_TRAIN: the profile of the timed compile itself (sqlite3.c, one lane), in place of the default training.
set -euo pipefail
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
"$BUSTER_PGO_COMPILER" --lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o train-sqlite3.o
