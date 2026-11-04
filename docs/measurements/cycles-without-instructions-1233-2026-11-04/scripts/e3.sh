#!/bin/bash
# #1233 E3: the checker's code at four offsets in each tree. main (M) and #1141's merge (H), each with its checker code
# moved by 0, 16, 32 and 48 bytes (e3-build.sh), two fresh copies of each on tmpfs (same path length), whole processes
# on CPU 2 under perf stat (cycles, instructions, dispatch slots with no ops from the front end, op-cache misses,
# backend-stalled slots: five counters, none multiplexed), the 16 executables' order rotated by run, one discarded
# warm-up each. Usage: e3.sh lua|sqlite RUNS (one hold of the lock).
set -u
export LC_ALL=C
R=$HOME/buster-fast-bench/1233-claude; L=$R/logs; E=$R/e3; mkdir -p $E/out
what=$1; runs=$2
head -1 /var/lib/buster-9700x/owner >> $L/holds.txt
: > $E/$what.csv
G="cycles:u,instructions:u,de_no_dispatch_per_slot.no_ops_from_frontend:u,op_cache_hit_miss.op_cache_miss:u,de_no_dispatch_per_slot.backend_stalls:u"
T=/tmp/claude-1233-e3
slots=()
for b in M:754475d4 H:4670b2eb; do
    for n in 00 16 32 48; do
        for c in 1 2; do
            d=$T/${b%%:*}$n-c$c; mkdir -p $d; cp $R/var/${b#*:}-$((10#$n))/compiler $d/compiler; slots+=(${b%%:*}$n-c$c)
        done
    done
done
sha256sum $T/*/compiler >> $L/receipts.txt
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
lua=(--lanes 1 -c -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -w $(ls $R/inputs/lua/*.c))
sqlite=(-c -o sqlite.o --predefines $C/provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include $C/sqlite/sqlite3.c)
one() { # run position slot
    local slot=$3; mkdir -p $E/out/$what-${slot%-c*}
    if [ $what = lua ]; then args=("${lua[@]}"); else args=("${sqlite[@]}"); fi
    (cd $E/out/$what-${slot%-c*} && taskset -c 2 perf stat -x, -o $E/one.csv -e "$G" -- $T/$slot/compiler "${args[@]}" > /dev/null 2> $E/err.txt)
    local status=$?
    grep -E '^[0-9<]' $E/one.csv | sed "s|^|tmpfs,$what,0,$1,$2,${slot%-c*},${slot#*-},$status,|" >> $E/$what.csv
}
for s in "${slots[@]}"; do one 0 0 $s; done
n=${#slots[@]}
for ((r = 1; r <= runs; r++)); do
    for ((k = 0; k < n; k++)); do one $r $k ${slots[$(((r + k) % n))]}; done
done
for d in $E/out/$what-*; do (cd $d && sha256sum *.o | sha256sum | sed "s|-|$(basename $d) objects|"); done >> $L/receipts.txt
# the copies go with the hold
for s in "${slots[@]}"; do unlink $T/$s/compiler; rmdir $T/$s; done; rmdir $T
echo "e3 $what $runs done" >> $L/receipts.txt
