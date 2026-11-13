#!/bin/bash
# explore-hot.sh LABEL INPUT: a cycles:u profile of the shadow on INPUT (sqlite or lua) by results/LABEL's compiler, --passes 40
# timing all three sweeps alone (BUSTER_NODE_SHADOW_ONLY=2), on CPU 2 in one hold of the lock; its samples' addresses and
# symbols kept (ips.txt), perf.data removed.
set -u
cd "$(dirname "$0")"
out=$PWD/results/$1/hot-$2
mkdir -p "$out"
compiler=$PWD/results/$1/compiler
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
lua=/home/david/buster-fast-bench/units-152-claude/inputs/lua-5.4.8/src
if [ "$2" = sqlite ]; then inputs="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c"; else inputs=$(echo $lua/*.c); fi
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner > $out/holder.txt; BUSTER_NODE_SHADOW_ONLY=2 taskset -c 2 perf record -q -c 20011 -e cycles:u -o $out/perf.data $compiler measure-node-machine --shadow --passes 40 $inputs > /dev/null 2>&1"
perf script -i $out/perf.data -F ip,sym 2>/dev/null | awk "{print \$1, \$2}" > $out/ips.txt
rm -f $out/perf.data
