#!/bin/bash
# explore-only.sh LABEL: the shadow on sqlite3.c by results/LABEL's compiler (main with patches/only.patch), on CPU 2, each run
# in its own hold of the lock: front-end and branch counts with --passes 0 and with --passes 40 timing one sweep set alone
# (BUSTER_NODE_SHADOW_ONLY=0: T, 1: T and C, 2: all three); each difference from --passes 0 is that set's 40 passes.
set -u
cd "$(dirname "$0")"
out=$PWD/results/$1/only
mkdir -p "$out"
compiler=$PWD/results/$1/compiler
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c"
e1=cycles:u,instructions:u,de_no_dispatch_per_slot.no_ops_from_frontend:u,ic_tag_hit_miss.instruction_cache_miss:u,ex_ret_brn_misp:u
e2=cycles:u,op_cache_hit_miss.op_cache_miss:u,op_cache_hit_miss.all_op_cache_accesses:u,de_no_dispatch_per_slot.backend_stalls:u,ex_ret_brn_tkn:u
for run in p0:0:x p40:40:0 p40:40:1 p40:40:2; do
    IFS=: read name p k <<< "$run"
    for e in 1 2; do
        ev=$([ $e = 1 ] && echo $e1 || echo $e2)
        ./lock.sh bash -c "BUSTER_NODE_SHADOW_ONLY=$k taskset -c 2 perf stat -e $ev -o $out/counts-$name-set$k-e$e.txt $compiler measure-node-machine --shadow --passes $p $options > $out/shadow-$name-set$k-e$e.txt 2>&1"
    done
done
