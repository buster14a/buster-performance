#!/bin/bash
# BUSTER_PGO_TRAIN script: the node machine's shadow on sqlite3.c (3 timing passes) by the instrumented compiler, so that
# the profile is of the sweeps (and the census around them) alone. Lua is left out, to be measured as unseen input.
set -eu
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
"$BUSTER_PGO_COMPILER" measure-node-machine --shadow --passes 3 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c" > /dev/null
