#!/bin/bash
# time.sh LABEL: the shadow's sweeps timed on sqlite3.c and Lua 5.4.8 by results/LABEL's compiler, 11 passes, CPU 2, one
# hold of the lock. From the step 1 record's time.sh.
set -u
cd "$(dirname "$0")"
label=$1
out=$PWD/results/$label
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
lua=/home/david/buster-fast-bench/units-152-claude/inputs/lua-5.4.8/src
export LC_ALL=C
./lock.sh bash -c "
head -1 /var/lib/buster-9700x/owner > '$out/time-holder.txt'
taskset -c 2 '$out/compiler' measure-node-machine --shadow --passes 11 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I'$sqlite' '$sqlite/sqlite3.c' > '$out/time-sqlite3.txt' 2>&1; echo \"status \$?\" >> '$out/time-sqlite3.txt'
taskset -c 2 '$out/compiler' measure-node-machine --shadow --passes 11 '$lua'/*.c > '$out/time-lua.txt' 2>&1; echo \"status \$?\" >> '$out/time-lua.txt'
"
date -u +%FT%TZ > "$out/.timed"
