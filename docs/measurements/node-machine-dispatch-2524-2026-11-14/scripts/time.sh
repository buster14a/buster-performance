#!/bin/bash
# time.sh LABEL [SUFFIX]: the shadow's sweeps timed on sqlite3.c and Lua 5.4.8 by results/LABEL's compiler, 11 passes
# (each sweep set's least), then again with each expression's sweeps run twice in a row (--repeat 2, the second run's
# inputs in the caches), CPU 2, one hold of the lock; the files are time-*SUFFIX.txt. ,
# with Lua's --repeat 2 besides.
set -u
cd "$(dirname "$0")"
out=$PWD/results/$1
suffix=${2-}
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
lua=$PWD/inputs/lua-5.4.8/src
export LC_ALL=C
./lock.sh bash -c "
head -1 /var/lib/buster-9700x/owner > '$out/time-holder$suffix.txt'
taskset -c 2 '$out/compiler' measure-node-machine --shadow --passes 11 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I'$sqlite' '$sqlite/sqlite3.c' > '$out/time-sqlite3$suffix.txt' 2>&1; echo \"status \$?\" >> '$out/time-sqlite3$suffix.txt'
taskset -c 2 '$out/compiler' measure-node-machine --shadow --passes 11 '$lua'/*.c > '$out/time-lua$suffix.txt' 2>&1; echo \"status \$?\" >> '$out/time-lua$suffix.txt'
taskset -c 2 '$out/compiler' measure-node-machine --shadow --passes 11 --repeat 2 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I'$sqlite' '$sqlite/sqlite3.c' > '$out/time-sqlite3-repeat2$suffix.txt' 2>&1; echo \"status \$?\" >> '$out/time-sqlite3-repeat2$suffix.txt'
taskset -c 2 '$out/compiler' measure-node-machine --shadow --passes 11 --repeat 2 '$lua'/*.c > '$out/time-lua-repeat2$suffix.txt' 2>&1; echo \"status \$?\" >> '$out/time-lua-repeat2$suffix.txt'
"
date -u +%FT%TZ > "$out/.timed$suffix"
