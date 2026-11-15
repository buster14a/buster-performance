#!/bin/bash
# counts-g.sh LABEL BATCH: as counts-b.sh, its --passes 40 runs of the three sets and three event groups for one batch
# size in one hold of the lock (nine perf stat runs of about three seconds each), skipping those already counted.
set -u
cd "$(dirname "$0")"
out=$PWD/results/$1/counts
mkdir -p "$out"
batch=$2
compiler=$PWD/results/$1/compiler
option=$([ "$batch" = - ] && echo "" || echo "--batch $batch")
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c"
e1=cycles:u,instructions:u,de_no_dispatch_per_slot.no_ops_from_frontend:u,ic_tag_hit_miss.instruction_cache_miss:u,ex_ret_brn_misp:u
e2=cycles:u,op_cache_hit_miss.op_cache_miss:u,op_cache_hit_miss.all_op_cache_accesses:u,de_no_dispatch_per_slot.backend_stalls:u,ex_ret_brn_ind_misp:u
e3=cycles:u,ls_any_fills_from_sys.all:u,ls_any_fills_from_sys.local_l2:u,l2_request_g1.all_dc:u,ex_ret_ind_brch_instr:u
commands="head -1 /var/lib/buster-9700x/owner >> $out/holds-b$batch.txt"
for k in 0 1 2; do
    for e in 1 2 3; do
        f=$out/counts-p40-set$k-b$batch-e$e.txt
        test -s "$f" && continue
        ev=$(eval echo \$e$e)
        commands="$commands; BUSTER_NODE_SHADOW_ONLY=$k taskset -c 2 perf stat -e $ev -o $f $compiler measure-node-machine --shadow --passes 40 $option $options > $out/shadow-p40-set$k-b$batch-e$e.txt 2>&1"
    done
done
./lock.sh bash -c "$commands"
