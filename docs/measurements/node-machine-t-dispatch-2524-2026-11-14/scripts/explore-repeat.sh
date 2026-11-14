#!/bin/bash
# explore-repeat.sh LABEL: as explore-only.sh, with --repeat 2 (each expression's sweeps twice in a row) for all three sets
# timed together (BUSTER_NODE_SHADOW_ONLY=2) and for T alone (0): the difference from explore-only.sh's --repeat 1 counts is
# the second run's, whose code and data the first left in the caches. Each run in its own hold of the lock, CPU 2.
set -u
cd "$(dirname "$0")"
out=$PWD/results/$1/repeat
mkdir -p "$out"
compiler=$PWD/results/$1/compiler
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c"
e1=cycles:u,instructions:u,de_no_dispatch_per_slot.no_ops_from_frontend:u,ic_tag_hit_miss.instruction_cache_miss:u,ex_ret_brn_misp:u
e2=cycles:u,op_cache_hit_miss.op_cache_miss:u,op_cache_hit_miss.all_op_cache_accesses:u,de_no_dispatch_per_slot.backend_stalls:u,ls_dmnd_fills_from_sys.all:u
for k in 0 2; do
    for e in 1 2; do
        ev=$([ $e = 1 ] && echo $e1 || echo $e2)
        ./lock.sh bash -c "BUSTER_NODE_SHADOW_ONLY=$k taskset -c 2 perf stat -e $ev -o $out/counts-p40-set$k-r2-e$e.txt $compiler measure-node-machine --shadow --passes 40 --repeat 2 $options > $out/shadow-p40-set$k-r2-e$e.txt 2>&1"
    done
done
