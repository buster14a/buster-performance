#!/usr/bin/env bash
# compile-count.sh REV: callgrind's instruction count of REV's x86-64 (scalar host) Release compiler compiling sqlite3.c
# by --tier1 -fno-asynchronous-unwind-tables and speedtest1's flags (#2618's cgcompile2.sh), and Lua's lvm.c, under
# ulimit -v 64 GiB (callgrind's address space refuses the arenas' larger reservations otherwise); the objects' hashes.
set -u
C=$HOME/.cache/claude-2767; t=$1; cd $C/compile
L=$C/S/inputs/lua-5.4.8/src
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
unset CPATH C_INCLUDE_PATH
ulimit -v 67108864
valgrind --tool=callgrind --callgrind-out-file=sqlite3-$t.cg ./compiler-$t-x86 --tier1 -fno-asynchronous-unwind-tables $FLAGS -I$C/corpus/sqlite -c -o sqlite3-$t.o $C/corpus/sqlite/sqlite3.c > sqlite3-$t.log 2>&1
echo "$t sqlite3 exit $? $(grep -m1 '^summary' sqlite3-$t.cg)"
valgrind --tool=callgrind --callgrind-out-file=lvm-$t.cg ./compiler-$t-x86 --tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o lvm-$t.o $L/lvm.c > lvm-$t.log 2>&1
echo "$t lvm exit $? $(grep -m1 '^summary' lvm-$t.cg)"
sha256sum sqlite3-$t.o lvm-$t.o
