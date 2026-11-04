#!/bin/bash
# #673: the never-grows control, 09e22269 (as main) against 7b930910 (as head), the test hook, SQLite -c under an empty jobserver.
B=~/buster-fast-bench/673-claude
C=~/buster-fast-bench/unclaimed-perf-20261028
M=$B/head-09e22269/build/compiler
H=$B/head-7b930910/build/compiler
O=$B/exp5-out
P=$O/progress
mkdir -p $O
F=$B/jobserver.fifo
[ -p $F ] || mkfifo $F
export EXCLUSIVE_OWNER=claude-673 EXCLUSIVE_TITLE="673: never-grows control, 09e22269 (as main) against 7b930910 (as head), the test hook" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/673
SQ="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -std=gnu17 --predefines corpus/gnu17-pinned-predefines.txt --clang-features --target=x86_64-linux-gnu -march=znver5 -nostdinc -isystem corpus/headers/usr/lib/clang/23/include -isystem corpus/headers/usr/local/include -isystem corpus/headers/usr/include -Icorpus/sqlite -c corpus/sqlite/sqlite3.c"
V=(main head)
N=${#V[@]}
rounds=${1:-30}
cd $C
for r in $(seq 1 $rounds); do
    order=""
    for i in $(seq 0 $((N - 1))); do order="$order ${V[$(( (i + r) % N ))]}"; done
    ~/buster-fast-bench/exclusive.sh bash -c "
        run() { exec 3<>$F; MAKEFLAGS='-j --jobserver-auth=fifo:$F' taskset -c 0-7 perf stat -x, -e cycles:u,instructions:u,cycles:k -o \$2 \$( [ \$1 = main ] && echo $M || echo $H ) $SQ -o $O/out-\$1.o; s=\$?; exec 3>&-; return \$s; }
        run head $O/warm.csv || exit 1
        for v in $order; do run \$v $O/r$r-v\$v.csv || exit 1; done"
    s=$?
    echo "$(date +%T) round $r order$order status $s" >> $P
    [ $s -eq 0 ] || break
    sleep 2
done
echo "$(date +%T) done" >> $P
