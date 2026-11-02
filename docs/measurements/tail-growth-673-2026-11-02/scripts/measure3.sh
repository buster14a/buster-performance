#!/bin/bash
# #673 never-grows cost: which of part order or part count is it? fb1ba1e2 with growing teams' parts in source order
# (var1) and costliest first then source order (var2), against main 3ce71ec3 and fb1ba1e2, under an empty jobserver.
B=~/buster-fast-bench/673-claude
C=~/buster-fast-bench/unclaimed-perf-20261028
export EXCLUSIVE_OWNER=claude-673 EXCLUSIVE_TITLE="solve 673: uneven-tail worker budget" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/673
P=$B/measure3.progress
for v in var1 var2; do
    cd $B/variants/$v && BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1
    echo "$(date +%T) build $v status=$?" >> $P
done
while pgrep -f "measure2.sh" > /dev/null; do sleep 20; done
cd $C
F=$B/jobserver.fifo
SQ="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -std=gnu17 --predefines corpus/gnu17-pinned-predefines.txt --clang-features --target=x86_64-linux-gnu -march=znver5 -nostdinc -isystem corpus/headers/usr/lib/clang/23/include -isystem corpus/headers/usr/local/include -isystem corpus/headers/usr/include -Icorpus/sqlite -c corpus/sqlite/sqlite3.c -o $B/timeruns3.o"
mkdir -p $B/copies3
~/buster-fast-bench/exclusive.sh bash -c "MAKEFLAGS='-j --jobserver-auth=fifo:$F' taskset -c 0-7 $B/main-3ce71ec3/build/compiler time-runs --runs 11 --warmups 1 --copies 2 --directory $B/copies3 --build main $B/main-3ce71ec3/build/compiler --build head $B/head-fb1ba1e2/build/compiler --build source $B/variants/var1/build/compiler --build costliest-source $B/variants/var2/build/compiler --list $SQ" > $B/v-timeruns-empty.log 2>&1
echo "$(date +%T) timeruns variants status=$?" >> $P
echo "$(date +%T) done" >> $P
