#!/bin/bash
# #673: the never-grows cost by variant of one executable (BUSTER_673_VARIANT; c_check_program_emit.c's experiment),
# SQLite -c under a jobserver with no spare token. Each lock hold is one round: a warm-up, then every variant once in
# rotated order, each under perf stat with the jobserver's FIFO opened afresh (empty).
B=~/buster-fast-bench/673-claude
C=~/buster-fast-bench/unclaimed-perf-20261028
X=$B/exp1/build/compiler
O=$B/exp1-out
P=$O/progress
mkdir -p $O
F=$B/jobserver.fifo
[ -p $F ] || mkfifo $F
export EXCLUSIVE_OWNER=claude-673 EXCLUSIVE_TITLE="673: never-grows cost by variant" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/673
SQ="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -std=gnu17 --predefines corpus/gnu17-pinned-predefines.txt --clang-features --target=x86_64-linux-gnu -march=znver5 -nostdinc -isystem corpus/headers/usr/lib/clang/23/include -isystem corpus/headers/usr/local/include -isystem corpus/headers/usr/include -Icorpus/sqlite -c corpus/sqlite/sqlite3.c"
V=(0 1 2 3 4 5)
rounds=${1:-40}
cd $C
for r in $(seq 1 $rounds); do
    order=""
    for i in 0 1 2 3 4 5; do order="$order ${V[$(( (i + r) % 6 ))]}"; done
    ~/buster-fast-bench/exclusive.sh bash -c "
        run() { exec 3<>$F; MAKEFLAGS='-j --jobserver-auth=fifo:$F' BUSTER_673_VARIANT=\$1 taskset -c 0-7 perf stat -x, -e duration_time,user_time,system_time,cycles:u,instructions:u,cycles:k -o \$2 $X $SQ -o $O/out-\$1.o; s=\$?; exec 3>&-; return \$s; }
        run 0 $O/warm.csv || exit 1
        for v in $order; do run \$v $O/r$r-v\$v.csv || exit 1; done"
    s=$?
    echo "$(date +%T) round $r order$order status $s" >> $P
    [ $s -eq 0 ] || break
    sleep 2
done
echo "$(date +%T) done" >> $P
