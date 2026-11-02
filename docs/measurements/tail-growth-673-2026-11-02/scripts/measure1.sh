#!/bin/bash
# #673 tail growth: main 3ce71ec3 against head-wip1 (tree 2443b068), each run its own lock hold.
B=~/buster-fast-bench/673-claude
C=~/buster-fast-bench/unclaimed-perf-20261028
E=issue673-spawn-1d/evidence-673-spawn
export EXCLUSIVE_OWNER=claude-673 EXCLUSIVE_TITLE="solve 673: uneven-tail worker budget" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/673
cd $C
policy() { # workload tree round
    local out=$B/w$1-$2-r$3
    ~/buster-fast-bench/exclusive.sh taskset -c 0-7 ./$E/policy_balanced $out $1 $B/$2/build/compiler ./$E/compile-budget.mk ./$E/usage_record > $out.log 2>&1
    echo "$(date +%T) policy w$1 $2 r$3 status=$?" >> $B/measure1.progress
    sleep 20
}
policy 2 main-3ce71ec3 2
policy 2 head-wip1 2
policy 0 main-3ce71ec3 1
policy 0 head-wip1 1
policy 1 main-3ce71ec3 1
policy 1 head-wip1 1
F=$B/jobserver.fifo
[ -p $F ] || mkfifo $F
SQ="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -std=gnu17 --predefines corpus/gnu17-pinned-predefines.txt --clang-features --target=x86_64-linux-gnu -march=znver5 -nostdinc -isystem corpus/headers/usr/lib/clang/23/include -isystem corpus/headers/usr/local/include -isystem corpus/headers/usr/include -Icorpus/sqlite -c corpus/sqlite/sqlite3.c -o $B/timeruns.o"
timeruns() { # name spare
    ~/buster-fast-bench/exclusive.sh bash -c "exec 3<>$F; head -c $2 /dev/zero >&3; MAKEFLAGS='-j --jobserver-auth=fifo:$F' taskset -c 0-7 $B/main-3ce71ec3/build/compiler time-runs --runs 11 --warmups 1 --copies 2 --directory $B/copies --build main $B/main-3ce71ec3/build/compiler --build head $B/head-wip1/build/compiler --list $SQ; exec 3>&-" > $B/timeruns-$1.log 2>&1
    echo "$(date +%T) timeruns $1 status=$?" >> $B/measure1.progress
    sleep 20
}
mkdir -p $B/copies
timeruns empty 0
timeruns spare7 7
echo "$(date +%T) done" >> $B/measure1.progress
