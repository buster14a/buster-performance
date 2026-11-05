#!/usr/bin/env bash
# identity.sh A B: --tier1 -c of the frozen sqlite3.c and of Lua 5.4.8's 34 sources by tree A and tree B, by the vector
# path and by --scalar, each pair of objects compared byte for byte; one hold of the shared lock, CPU 2.
. ~/buster-fast-bench/claude-141-takeover/common.sh
a=$1
b=$2
out=$RUNDIR/identity-$a-$b
rm -rf $out
mkdir -p $out
export a b out PWD FLAGS Q LUA
"$lock" bash -c '
same=0
differ=0
for t in $a $b; do
    for p in vector scalar; do
        mkdir -p $out/$t-$p
        opt=$([ $p = scalar ] && echo --scalar)
        taskset -c 2 $PWD/$t/build/compiler --tier1 $opt -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o $out/$t-$p/sqlite3.o $Q/sqlite3.c
        for f in $LUA/*.c; do
            n=$(basename $f .c)
            taskset -c 2 $PWD/$t/build/compiler --tier1 $opt -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o $out/$t-$p/$n.o $f
        done
    done
done
for p in vector scalar; do
    for o in $out/$a-$p/*.o; do
        n=$(basename $o)
        if cmp -s $o $out/$b-$p/$n; then same=$((same + 1)); else differ=$((differ + 1)); echo "differs: $p $n"; fi
    done
done
echo "$a against $b, by both paths: $same objects identical, $differ differ"
'
