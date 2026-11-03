#!/bin/bash
# #673 never-grows cost by parts per lane (costliest part first, then source order): 64 (var2), 32 (var6) and 16 (var5)
# per lane, against main 3ce71ec3, under an empty jobserver; and the partial grant (3 spare tokens, 4 of 8 lanes) of
# fb1ba1e2 and var2 against main. Each build and each time-runs takes the lock itself.
B=~/buster-fast-bench/673-claude
C=~/buster-fast-bench/unclaimed-perf-20261028
export EXCLUSIVE_OWNER=claude-673 EXCLUSIVE_TITLE="solve 673: uneven-tail worker budget" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/673
P=$B/measure4.progress
for v in var5 var6; do
    cd $B/variants/$v && BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1
    echo "$(date +%T) build $v status=$?" >> $P
done
cd $C
F=$B/jobserver.fifo
SQ="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -std=gnu17 --predefines corpus/gnu17-pinned-predefines.txt --clang-features --target=x86_64-linux-gnu -march=znver5 -nostdinc -isystem corpus/headers/usr/lib/clang/23/include -isystem corpus/headers/usr/local/include -isystem corpus/headers/usr/include -Icorpus/sqlite -c corpus/sqlite/sqlite3.c -o $B/timeruns4.o"
mkdir -p $B/copies4
~/buster-fast-bench/exclusive.sh bash -c "MAKEFLAGS='-j --jobserver-auth=fifo:$F' taskset -c 0-7 $B/main-3ce71ec3/build/compiler time-runs --runs 11 --warmups 1 --copies 2 --directory $B/copies4 --build main $B/main-3ce71ec3/build/compiler --build parts64 $B/variants/var2/build/compiler --build parts32 $B/variants/var6/build/compiler --build parts16 $B/variants/var5/build/compiler --list $SQ" > $B/v4-timeruns-empty.log 2>&1
echo "$(date +%T) timeruns parts status=$?" >> $P
sleep 20
~/buster-fast-bench/exclusive.sh bash -c "exec 3<>$F; head -c 3 /dev/zero >&3; MAKEFLAGS='-j --jobserver-auth=fifo:$F' taskset -c 0-7 $B/main-3ce71ec3/build/compiler time-runs --runs 11 --warmups 1 --copies 2 --directory $B/copies4 --build main $B/main-3ce71ec3/build/compiler --build head $B/head-fb1ba1e2/build/compiler --build parts64 $B/variants/var2/build/compiler --build parts16 $B/variants/var5/build/compiler --list $SQ; status=\$?; exec 3>&-; exit \$status" > $B/v4-timeruns-spare3.log 2>&1
echo "$(date +%T) timeruns spare3 status=$?" >> $P
echo "$(date +%T) done" >> $P
