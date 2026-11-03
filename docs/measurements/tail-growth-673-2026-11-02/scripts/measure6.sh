#!/bin/bash
# #673 tail growth, requalification on the integrated tree: main $2 (main-<short commit>) against the head tree named by
# $1 (head-<short commit>), measure5.sh's method, both built here, each build and run its own lock hold.
B=~/buster-fast-bench/673-claude
C=~/buster-fast-bench/unclaimed-perf-20261028
E=issue673-spawn-1d/evidence-673-spawn
H=$1
M=$2
export EXCLUSIVE_OWNER=claude-673 EXCLUSIVE_TITLE="solve 673: uneven-tail worker budget (integrated tree)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1161
P=$B/final-$H.progress
for T in $M $H; do
    cd $B/$T && BUSTER_HOST_ARCH=znver5 ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1
    echo "$(date +%T) build $T status=$?" >> $P
    sleep 20
done
{
    date -u; uname -a; clang --version | head -1; perf --version; make --version | head -1
    cat /sys/devices/system/cpu/cpu{0,1,2,3,4,5,6,7}/cpufreq/scaling_governor | sort | uniq -c
    sha256sum $B/$M/build/compiler $B/$H/build/compiler $C/corpus/sqlite/sqlite3.c $C/corpus/gnu17-pinned-predefines.txt $C/$E/tiny.c \
        $C/$E/policy_balanced $C/$E/policy_balanced.c $C/$E/compile-budget.mk $C/$E/usage_record
    echo "main $(cat $B/$M/COMMIT)"; echo "head $(cat $B/$H/COMMIT)"
} > $B/final-$H-receipts.txt 2>&1
cd $C
policy() { # workload tree round
    local out=$B/final-$H/w$1-$2-r$3
    mkdir -p $B/final-$H
    ~/buster-fast-bench/exclusive.sh taskset -c 0-7 ./$E/policy_balanced $out $1 $B/$2/build/compiler ./$E/compile-budget.mk ./$E/usage_record > $out.log 2>&1
    echo "$(date +%T) policy w$1 $2 r$3 status=$?" >> $P
    sleep 20
}
policy 2 $M 1
policy 2 $H 1
policy 0 $M 1
policy 0 $H 1
policy 2 $H 2
policy 2 $M 2
policy 0 $H 2
policy 0 $M 2
policy 1 $M 1
policy 1 $H 1
F=$B/jobserver.fifo
[ -p $F ] || mkfifo $F
SQ="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -std=gnu17 --predefines corpus/gnu17-pinned-predefines.txt --clang-features --target=x86_64-linux-gnu -march=znver5 -nostdinc -isystem corpus/headers/usr/lib/clang/23/include -isystem corpus/headers/usr/local/include -isystem corpus/headers/usr/include -Icorpus/sqlite -c corpus/sqlite/sqlite3.c -o $B/final-$H/timeruns.o"
timeruns() { # name makeflags spare
    ~/buster-fast-bench/exclusive.sh bash -c "exec 3<>$F; head -c $3 /dev/zero >&3; MAKEFLAGS='$2' taskset -c 0-7 $B/$M/build/compiler time-runs --runs 11 --warmups 1 --copies 2 --directory $B/final-$H/copies --build main $B/$M/build/compiler --build head $B/$H/build/compiler --list $SQ; status=\$?; exec 3>&-; exit \$status" > $B/final-$H/timeruns-$1.log 2>&1
    echo "$(date +%T) timeruns $1 status=$?" >> $P
    sleep 20
}
mkdir -p $B/final-$H/copies
timeruns empty "-j --jobserver-auth=fifo:$F" 0
timeruns spare3 "-j --jobserver-auth=fifo:$F" 3
timeruns spare7 "-j --jobserver-auth=fifo:$F" 7
timeruns none "" 0
echo "$(date +%T) done" >> $P
