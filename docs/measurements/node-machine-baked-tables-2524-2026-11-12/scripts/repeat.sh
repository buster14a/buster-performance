#!/bin/bash
# repeat.sh LABEL: results/LABEL's compiler timed as time.sh times it, with each expression's sweeps run twice in a row
# (--repeat 2), one hold of the lock: the second run's cost is the sweeps' with their inputs in the caches.
set -u
cd "$(dirname "$0")"
out=$PWD/results/$1
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
lua=/home/david/buster-fast-bench/units-152-claude/inputs/lua-5.4.8/src
./lock.sh bash -c "
head -1 /var/lib/buster-9700x/owner > '$out/repeat-holder.txt'
taskset -c 2 '$out/compiler' measure-node-machine --shadow --passes 11 --repeat 2 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I'$sqlite' '$sqlite/sqlite3.c' > '$out/sqlite3-repeat2.txt' 2>&1; echo \"status \$?\" >> '$out/sqlite3-repeat2.txt'
taskset -c 2 '$out/compiler' measure-node-machine --shadow --passes 11 --repeat 2 '$lua'/*.c > '$out/lua-repeat2.txt' 2>&1; echo \"status \$?\" >> '$out/lua-repeat2.txt'
"
date -u +%FT%TZ > "$out/.repeated"
