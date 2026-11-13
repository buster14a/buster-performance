#!/bin/bash
# explore-sets.sh LABEL INPUT [SUFFIX]: the shadow on INPUT (sqlite or lua) by results/LABEL's compiler (patches/only.patch), on CPU 2,
# each run in its own hold of the lock: counts with --passes 0 and with --passes 40 timing one sweep set alone
# (BUSTER_NODE_SHADOW_ONLY=0: T, 1: T and C, 2: all three), each set's 40 passes being its difference from --passes 0.
set -u
cd "$(dirname "$0")"
out=$PWD/results/$1/sets-$2${3:-}
mkdir -p "$out"
compiler=$PWD/results/$1/compiler
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
lua=/home/david/buster-fast-bench/units-152-claude/inputs/lua-5.4.8/src
if [ "$2" = sqlite ]; then inputs="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c"; else inputs=$(echo $lua/*.c); fi
events=cycles:u,instructions:u,de_no_dispatch_per_slot.no_ops_from_frontend:u,ic_tag_hit_miss.instruction_cache_miss:u,ex_ret_brn_misp:u
for run in 0:x 40:0 40:1 40:2; do
    IFS=: read p k <<< "$run"
    ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner > $out/holder-p$p-set$k.txt; BUSTER_NODE_SHADOW_ONLY=$k taskset -c 2 perf stat -e $events -o $out/counts-p$p-set$k.txt $compiler measure-node-machine --shadow --passes $p $inputs > $out/shadow-p$p-set$k.txt 2>&1"
done
