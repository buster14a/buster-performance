#!/bin/bash
# explore-fe.sh LABEL: the shadow on sqlite3.c by results/LABEL's compiler, on CPU 2, each run in its own hold of the lock:
# the front end's counts with --passes 0 and 40 (their difference is the sweeps'), then a profile of each by symbol.
set -u
cd "$(dirname "$0")"
out=$PWD/results/$1/fe
mkdir -p "$out"
compiler=$PWD/results/$1/compiler
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c"
events=cycles:u,de_no_dispatch_per_slot.no_ops_from_frontend:u,op_cache_hit_miss.op_cache_miss:u,op_cache_hit_miss.all_op_cache_accesses:u,ic_tag_hit_miss.instruction_cache_miss:u,bp_l1_tlb_miss_l2_tlb_hit:u
for p in 0 40; do
    ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner > $out/holder-p$p.txt; taskset -c 2 perf stat -e $events -o $out/counts-p$p.txt $compiler measure-node-machine --shadow --passes $p $options > /dev/null 2>&1"
done
./lock.sh bash -c "taskset -c 2 perf record -q -c 200003 -e $events -o $out/perf-fe.data $compiler measure-node-machine --shadow --passes 40 $options > /dev/null 2>&1"
perf report -i $out/perf-fe.data --stdio --no-children --sort symbol 2>/dev/null | grep -v "^$" | grep -E "^# Samples|^# Event count|node_machine|check_action|type_lookup|node_census" | head -120 > $out/symbols.txt
rm -f $out/perf-fe.data
