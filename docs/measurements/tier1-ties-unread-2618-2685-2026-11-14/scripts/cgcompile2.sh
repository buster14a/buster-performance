#!/usr/bin/env bash
# cgcompile2.sh: main and head at BUSTER_HOST_ARCH=x86-64 (Release), then sqlite3.c's --tier1 -c under callgrind for each
# (#2618's second part's cgcompile.sh with its paths renamed and the Release configuration).
set -u
C=~/.cache/claude-2618b
Q=$C/S/corpus/sqlite
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
mkdir -p $C/cg
for t in main head; do
  (cd $C/wt-$t && BUSTER_HOST_ARCH=x86-64 BUSTER_DEBUG_INFO=0 nice ./build.sh --config Release --jobs 4 > $C/cg/build-$t.log 2>&1; echo "build $t exit $?")
done
unset CPATH C_INCLUDE_PATH
for t in main head; do
  (ulimit -v 67108864; cd $C/cg && valgrind --tool=callgrind --callgrind-out-file=$C/cg/compile-$t.cg $C/wt-$t/build/compiler --tier1 -fno-asynchronous-unwind-tables $FLAGS -I$Q -c -o $C/cg/sqlite3-$t.o $Q/sqlite3.c > $C/cg/cg-$t.out 2>&1; echo "callgrind $t exit $?") &
done
wait
for t in main head; do echo "$t $(grep -m1 '^summary' $C/cg/compile-$t.cg)"; done
