#!/bin/bash
# time.sh LABEL [COMPILER-LABEL]: the shadow's sweeps timed on sqlite3.c and Lua 5.4.8 by results/COMPILER-LABEL's
# compiler (LABEL's by default), CPU 2, 11 passes, one hold of the lock; written to results/LABEL.
set -u
cd "$(dirname "$0")"
out=$PWD/results/$1
compiler=$PWD/results/${2:-$1}/compiler
mkdir -p "$out"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
lua=/home/david/buster-fast-bench/units-152-claude/inputs/lua-5.4.8/src
export LC_ALL=C
./lock.sh bash -c "
head -1 /var/lib/buster-9700x/owner > '$out/holder.txt'
sha256sum '$compiler' > '$out/timed-compiler.txt'
taskset -c 2 '$compiler' measure-node-machine --shadow --passes 11 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I'$sqlite' '$sqlite/sqlite3.c' > '$out/sqlite3.txt' 2>&1; echo \"status \$?\" >> '$out/sqlite3.txt'
taskset -c 2 '$compiler' measure-node-machine --shadow --passes 11 '$lua'/*.c > '$out/lua.txt' 2>&1; echo \"status \$?\" >> '$out/lua.txt'
"
date -u +%FT%TZ > "$out/.timed"
