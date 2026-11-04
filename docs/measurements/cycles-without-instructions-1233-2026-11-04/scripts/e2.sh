#!/bin/bash
# #1233 E2: where the merge's extra front-end stalls are, by function. perf record of three sampled user events at
# once, each under the host's sample-rate cap (63,300/s, HZ 300): cycles (period 200003), dispatch slots with no ops
# from the front end (800011) and op-cache misses (40009), over whole processes of Lua's 33 units by --lanes 1 -c on
# CPU 2, the builds M, H and A interleaved process by process in a rotating order, one discarded warm-up each, each
# process's samples in its own file. Usage: e2.sh RUNS (one hold of the lock).
set -u
export LC_ALL=C
R=$HOME/buster-fast-bench/1233-claude; L=$R/logs; E=$R/e2; mkdir -p $E/out
runs=$1
head -1 /var/lib/buster-9700x/owner >> $L/holds.txt
events='cycles/period=200003/u,de_no_dispatch_per_slot.no_ops_from_frontend/period=800011/u,op_cache_hit_miss.op_cache_miss/period=40009/u'
builds=(M H A)
lua=(-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -w)
luafiles=$(ls $R/inputs/lua/*.c)
for b in M H A; do mkdir -p $E/out/lua-$b; done
one() { # build run
    local b=$1 r=$2
    (cd $E/out/lua-$b && taskset -c 2 perf record -q -e $events -o $E/lua-$b-$r.data -- $R/bin/$b/compiler --lanes 1 -c "${lua[@]}" $luafiles > /dev/null 2>> $E/err.txt)
    echo "lua $b $r status $?" >> $E/status.txt
}
for b in M H A; do one $b 0; done
for ((r = 1; r <= runs; r++)); do
    for k in 0 1 2; do one ${builds[$(((r + k) % 3))]} $r; done
done
echo "e2 lua $runs done" >> $L/receipts.txt
