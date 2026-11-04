#!/bin/bash
# #673: where the parts' cycles go. Variants 1 (no growth), 5 (one part), 3 (16 parts) and 0 (128 parts, as merged) of
# exp1's executable, SQLite -c under an empty jobserver, with two groups of user-mode events (front end, memory) in
# separate runs so that neither multiplexes. One lock hold per round, a warm-up first, the order rotated.
B=~/buster-fast-bench/673-claude
C=~/buster-fast-bench/unclaimed-perf-20261028
X=$B/exp1/build/compiler
O=$B/exp2-out
P=$O/progress
mkdir -p $O
F=$B/jobserver.fifo
[ -p $F ] || mkfifo $F
export EXCLUSIVE_OWNER=claude-673 EXCLUSIVE_TITLE="673: never-grows cost, cache events by variant" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/673
SQ="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -std=gnu17 --predefines corpus/gnu17-pinned-predefines.txt --clang-features --target=x86_64-linux-gnu -march=znver5 -nostdinc -isystem corpus/headers/usr/lib/clang/23/include -isystem corpus/headers/usr/local/include -isystem corpus/headers/usr/include -Icorpus/sqlite -c corpus/sqlite/sqlite3.c"
GA="cycles:u,instructions:u,ic_tag_hit_miss.instruction_cache_miss:u,op_cache_hit_miss.op_cache_miss:u,de_no_dispatch_per_slot.no_ops_from_frontend:u,bp_l1_tlb_miss_l2_tlb_miss.all:u"
GB="cycles:u,l2_cache_req_stat.ic_dc_miss_in_l2:u,ls_dmnd_fills_from_sys.all:u,ls_dmnd_fills_from_sys.dram_io_all:u,de_no_dispatch_per_slot.backend_stalls:u,ex_no_retire.load_not_complete:u"
V=(1 5 3 0)
rounds=${1:-20}
cd $C
for r in $(seq 1 $rounds); do
    order=""
    for i in 0 1 2 3; do order="$order ${V[$(( (i + r) % 4 ))]}"; done
    ~/buster-fast-bench/exclusive.sh bash -c "
        run() { exec 3<>$F; MAKEFLAGS='-j --jobserver-auth=fifo:$F' BUSTER_673_VARIANT=\$1 taskset -c 0-7 perf stat -x, -e \$3 -o \$2 $X $SQ -o $O/out-\$1.o; s=\$?; exec 3>&-; return \$s; }
        run 0 $O/warm.csv cycles:u || exit 1
        for v in $order; do run \$v $O/r$r-a-v\$v.csv $GA || exit 1; run \$v $O/r$r-b-v\$v.csv $GB || exit 1; done"
    s=$?
    echo "$(date +%T) round $r order$order status $s" >> $P
    [ $s -eq 0 ] || break
    sleep 2
done
echo "$(date +%T) done" >> $P
