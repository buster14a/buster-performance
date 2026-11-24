#!/bin/bash
for i in $(seq 20); do /home/david/buster-fast-bench/1340-truth/bin/compiler-head --lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c -o x.o || echo fail; done
