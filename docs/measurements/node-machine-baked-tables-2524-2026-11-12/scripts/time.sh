#!/bin/bash
# time.sh LABEL: the shadow's sweeps timed on sqlite3.c and Lua 5.4.8 by src/build/compiler, CPU 2, one hold of the lock.
set -u
cd "$(dirname "$0")"
label=$1
out=$PWD/results/$label
mkdir -p "$out"
cp ${TREE:-src}/build/compiler "$out/compiler"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
lua=/home/david/buster-fast-bench/units-152-claude/inputs/lua-5.4.8/src
export LC_ALL=C
./lock.sh bash -c "
head -1 /var/lib/buster-9700x/owner > '$out/holder.txt'
taskset -c 2 '$out/compiler' measure-node-machine --shadow --passes 11 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I'$sqlite' '$sqlite/sqlite3.c' > '$out/sqlite3.txt' 2>&1; echo \"status \$?\" >> '$out/sqlite3.txt'
taskset -c 2 '$out/compiler' measure-node-machine --shadow --passes 11 '$lua'/*.c > '$out/lua.txt' 2>&1; echo \"status \$?\" >> '$out/lua.txt'
"
date -u +%FT%TZ > "$out/.done"
