#!/bin/bash
# callgrind-compile.sh VARIANT (default or unroll): callgrind of a baseline-host compiler's `--tier1 -c sqlite3.c`.
# Run in a buster checkout after `BUSTER_HOST_ARCH=x86-64 ./build.sh` (valgrind has no AVX-512); COMPILER, Q (the
# frozen sqlite directory) and S (where outputs go) may be overridden. The arenas' reservations need the ulimit.
S=${S:-$PWD}
Q=${Q:-build/corpus/sqlite}
COMPILER=${COMPILER:-build/cmake/x86-64/Develop/compiler}
X=""
[ "$1" = unroll ] && X="--tier1-passes=+unroll"
ulimit -v 67108864
valgrind --tool=callgrind --callgrind-out-file=$S/cg-compile-$1.out $COMPILER --tier1 -c --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$Q $Q/sqlite3.c $X -o $S/cg-$1.o > $S/cg-$1.log 2>&1
echo "$1 exit $?"
