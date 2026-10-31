#!/bin/bash
# build.sh COMPILER NAME [options]: speedtest1 by the compiler's direct path, as st-NAME (#136's flags).
Q=$HOME/.cache/claude-174/corpus/sqlite
SRC=$HOME/.cache/claude-speedtest1-136/result/src
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
c=$1; n=$2; shift 2
d=$(dirname "$0")
$c "$@" $FLAGS -I$Q -o $d/st-$n $SRC/speedtest1-unity.c -lm
