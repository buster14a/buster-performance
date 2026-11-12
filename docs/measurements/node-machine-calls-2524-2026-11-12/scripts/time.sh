#!/bin/bash
# time.sh LABEL: the shadow's sweeps timed on sqlite3.c and Lua 5.4.8 by results/LABEL's compiler, 11 passes (each sweep
# set's least), then again with each expression's sweeps run twice in a row (--repeat 2, the second run's inputs in the
# caches), CPU 2, one hold of the lock. As 2524-claude-step1's time.sh and repeat.sh.
set -u
cd "$(dirname "$0")"
out=$PWD/results/$1
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
lua=/home/david/buster-fast-bench/units-152-claude/inputs/lua-5.4.8/src
export LC_ALL=C
./lock.sh bash -c "
head -1 /var/lib/buster-9700x/owner > '$out/time-holder.txt'
taskset -c 2 '$out/compiler' measure-node-machine --shadow --passes 11 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I'$sqlite' '$sqlite/sqlite3.c' > '$out/time-sqlite3.txt' 2>&1; echo \"status \$?\" >> '$out/time-sqlite3.txt'
taskset -c 2 '$out/compiler' measure-node-machine --shadow --passes 11 '$lua'/*.c > '$out/time-lua.txt' 2>&1; echo \"status \$?\" >> '$out/time-lua.txt'
taskset -c 2 '$out/compiler' measure-node-machine --shadow --passes 11 --repeat 2 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I'$sqlite' '$sqlite/sqlite3.c' > '$out/time-sqlite3-repeat2.txt' 2>&1; echo \"status \$?\" >> '$out/time-sqlite3-repeat2.txt'
"
date -u +%FT%TZ > "$out/.timed"
