#!/bin/bash
# time-orders-g.sh LABEL SUFFIX: time-order.sh's runs for orders 0, 1 and 2 at batches 4, 16 and 256, on sqlite3.c and Lua,
# all in one hold of the lock (18 runs of one to two seconds each), skipping those already timed.
set -u
cd "$(dirname "$0")"
out=$PWD/results/$1
suffix=$2
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
lua=$PWD/inputs/lua-5.4.8/src
export LC_ALL=C
commands="head -1 /var/lib/buster-9700x/owner >> $out/holds-orders$suffix.txt"
for b in 4 16 256; do
    for o in 0 1 2; do
        f=$out/time-o$o-b$b-sqlite3$suffix.txt
        grep -q "status 0" "$f" 2>/dev/null && continue
        commands="$commands; BUSTER_NODE_SHADOW_ORDER=$o taskset -c 2 $out/compiler measure-node-machine --shadow --passes 11 --batch $b -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c > $f 2>&1; echo status \$? >> $f"
        f=$out/time-o$o-b$b-lua$suffix.txt
        commands="$commands; BUSTER_NODE_SHADOW_ORDER=$o taskset -c 2 $out/compiler measure-node-machine --shadow --passes 11 --batch $b $lua/*.c > $f 2>&1; echo status \$? >> $f"
    done
done
./lock.sh bash -c "$commands"
