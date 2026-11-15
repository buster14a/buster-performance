#!/bin/bash
# counts-b.sh LABEL BATCH: perf stat of the shadow on sqlite3.c by results/LABEL's compiler (built with an only patch:
# BUSTER_NODE_SHADOW_ONLY=k times sweep set k alone), CPU 2, each run its own hold of the lock: three event groups, with
# --passes 0 (BATCH p0, once a label) and --passes 40 for each set; --batch BATCH ("-": no option). Each set's 40 passes
# are its run less the run of none.
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
runs="p40:40:0 p40:40:1 p40:40:2"
test -f "$out/counts-p0-setx-e3.txt" || runs="p0:0:x $runs"
for run in $runs; do
    IFS=: read name p k <<< "$run"
    for e in 1 2 3; do
        ev=$(eval echo \$e$e)
        b=$([ $name = p0 ] && echo "" || echo "-b$batch")
        ./lock.sh bash -c "BUSTER_NODE_SHADOW_ONLY=$k taskset -c 2 perf stat -e $ev -o $out/counts-$name-set$k$b-e$e.txt $compiler measure-node-machine --shadow --passes $p $option $options > $out/shadow-$name-set$k$b-e$e.txt 2>&1"
    done
done
