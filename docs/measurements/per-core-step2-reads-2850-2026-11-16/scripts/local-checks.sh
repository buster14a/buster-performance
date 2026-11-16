#!/bin/bash
# local-checks.sh: the piece's local checks on the published build/compiler (the cloud container, not the 9700X): the
# call-graph test, the compiler on its own source, every variant of the fact words' kernels on the compiler's own source
# and on sqlite3.c (no record may differ), and the census of what reads T's record on both and on Lua.
cd /home/user/buster
S=${SCRATCH:?the scratch directory, with corpus/sqlite and corpus/lua}
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
MAIN='-march=native -Isrc -fwrapv -funsigned-char --predefines build/predefines.h src/buster/compiler/main.c'
SQ="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$S/corpus/sqlite $S/corpus/sqlite/sqlite3.c"
LUA="$S/corpus/lua/lua-5.4.8/src/*.c"
./build/compiler test-call-graph 2>&1 | tail -1
./build/compiler parse -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char --predefines build/predefines.h src/buster/compiler/main.c > /dev/null 2>&1; echo "self-parse status $?"
./build/compiler -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror src/buster/compiler/main.c > /dev/null 2>&1; echo "self-check status $?"
for v in "--facts" "--facts-lean" "--facts-loads" "--facts --facts-operators" "--facts-lean --facts-operators" "--facts --facts-operators --facts-packed" "--facts --facts-operators --facts-window 16"; do
    for unit in main sqlite3; do
        if [ $unit = main ]; then arguments=$MAIN; else arguments=$SQ; fi
        out=$(./build/compiler measure-node-machine --shadow $v --passes 0 $arguments 2>&1); status=$?
        echo "$unit [$v] status=$status $(echo "$out" | grep -E '^node-facts: taken' | cut -c13-200)"
    done
done
for unit in main sqlite3 lua; do
    case $unit in main) arguments=$MAIN ;; sqlite3) arguments=$SQ ;; lua) arguments=$LUA ;; esac
    start=$(date +%s%N)
    out=$(./build/compiler measure-node-machine --shadow --facts-reads --passes 0 $arguments 2>&1); status=$?
    echo "$unit [--facts-reads] status=$status wall=$(( ($(date +%s%N) - start) / 1000000 )) ms"
    echo "$out" | grep -E '^node-reads: (expressions|runs|kind=[a-z]+ records)|^node-facts: taken' | cut -c1-300
done
echo local checks done
