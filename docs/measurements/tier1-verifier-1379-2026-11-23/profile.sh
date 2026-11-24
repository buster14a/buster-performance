#!/bin/sh
# One build ($1): perf record -e cycles:u of three -c -w --tier1 --lanes=1 compiles of sqlite3.c (the issue's
# options), and of Lua 5.4.8's lvm.c, on CPU 2; then the per-symbol report.
D=/tmp/c1341/w; S=$D/s1379; cd $S; b=$1; mkdir -p raw
SQ=/home/david/buster-fast-bench/1296-codex-20261105/corpus/sqlite; LUA=/home/david/buster-fast-bench/3130-claude/inputs/lua
C=$D/bin/$b
cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6
cat > raw/sq-$b.sh <<S
for i in 1 2 3; do $C -c -w --tier1 --lanes=1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$SQ $SQ/sqlite3.c -o $S/raw/sq-$b.o || exit 1; done
S
cat > raw/lua-$b.sh <<S
for i in 1 2 3 4 5 6 7 8 9 10; do $C -c -w --tier1 --lanes=1 -I$LUA $LUA/lvm.c -o $S/raw/lvm-$b.o || exit 1; done
S
taskset -c 2 perf record -q -e cycles:u -o raw/sq-$b.data sh raw/sq-$b.sh; echo "sqlite perf status $?"
taskset -c 2 perf record -q -e cycles:u -o raw/lua-$b.data sh raw/lua-$b.sh; echo "lua perf status $?"
for i in 1 2 3 4 5; do s=$(date +%s%N); taskset -c 2 $C -c -w --tier1 --lanes=1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$SQ $SQ/sqlite3.c -o raw/sq-$b.o; echo "$b sqlite3.c --tier1 --lanes=1 run $i $(( ($(date +%s%N)-s)/1000 )) us"; done
for i in 1 2 3 4 5; do s=$(date +%s%N); taskset -c 2 $C -c -w --tier1 --lanes=1 -I$LUA $LUA/lvm.c -o raw/lvm-$b.o; echo "$b lvm.c --tier1 --lanes=1 run $i $(( ($(date +%s%N)-s)/1000 )) us"; done
cat /proc/loadavg
