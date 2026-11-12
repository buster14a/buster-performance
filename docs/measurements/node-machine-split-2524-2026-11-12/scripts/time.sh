#!/bin/bash
# time.sh LABEL TREE: the shadow's sweeps timed (--passes 11, the least of 11 passes a sweep set) on the frozen sqlite3.c
# and Lua 5.4.8's 34 sources by TREE's build/compiler, copied to results/LABEL, CPU 2, in one hold of the lock.
set -u
cd "$(dirname "$0")"
label=$1
tree=$2
out=$PWD/results/$label
mkdir -p "$out"
cp "$tree/build/compiler" "$out/compiler"
git -C "$tree" log --oneline -1 > "$out/commit.txt"
sha256sum "$out/compiler" >> "$out/commit.txt"
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
