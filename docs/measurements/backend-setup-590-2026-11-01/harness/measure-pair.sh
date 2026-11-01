#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# measure-pair.sh BASE HEAD LOGS: #590 / buster14a/buster#1027 measurements on benchpress (Ryzen 7 9700X) of two checkouts in
# ~/buster-fast-bench/590-claude, each built here by `BUSTER_DEBUG_INFO=0 ./build.sh`. Every build, compile and
# measurement takes the shared lock per run (exclusive.sh) and is pinned to CPU 2; rounds alternate the builds' order.
set -u
base=$1
head=$2
log=$3
cd ~/buster-fast-bench/590-claude
mkdir -p "$log" objects-$log
export EXCLUSIVE_OWNER=claude-590 EXCLUSIVE_TITLE="#590 backend setup measurements (PR #1027)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1027
ex=~/buster-fast-bench/exclusive.sh
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
for t in $base $head; do
    [ -x $t/build/compiler ] || (cd $t && $ex env BUSTER_DEBUG_INFO=0 ./build.sh) > $log/build-$t.log 2>&1
done
{
    date -u
    uname -a
    echo "THP enabled: $(cat /sys/kernel/mm/transparent_hugepage/enabled), defrag: $(cat /sys/kernel/mm/transparent_hugepage/defrag)"
    grep -m1 "model name" /proc/cpuinfo
    sha256sum /usr/bin/tcc "$sqlite/sqlite3.c" $base/build/compiler $head/build/compiler
    for t in $base $head; do echo "$t: $(git -C $t log -1 --format='%H %s')"; size $t/build/compiler; done
} > $log/host.txt 2>&1
sed -n 's|^\([0-9][0-9]*\)$|c-testsuite/tests/single-exec/\1.c|p' $head/tests/c-testsuite/subset.txt > $log/subset.list
$ex bash -c "d=0; n=0; while read f; do id=\$(basename \$f .c); $base/build/compiler -c -o objects-$log/\$id.base.o \$f 2>/dev/null; a=\$?; $head/build/compiler -c -o objects-$log/\$id.head.o \$f 2>/dev/null; b=\$?; n=\$((n+1)); { [ \$a = 0 ] && [ \$b = 0 ] && cmp -s objects-$log/\$id.base.o objects-$log/\$id.head.o; } || { d=\$((d+1)); echo \"differs: \$f (\$a/\$b)\"; }; done < $log/subset.list; $base/build/compiler -c -o objects-$log/hello.base.o harness/hello.c && $head/build/compiler -c -o objects-$log/hello.head.o harness/hello.c && cmp objects-$log/hello.base.o objects-$log/hello.head.o || d=\$((d+1)); echo \"objects: \$n c-testsuite programs and hello.c, \$d differ\"" > $log/objects.txt 2>&1
for round in 1 2 3; do
    if [ $((round % 2)) = 1 ]; then order="$base $head"; else order="$head $base"; fi
    for cond in always disabled; do
        wrap=""
        [ $cond = disabled ] && wrap=harness/nothp
        for t in $order; do
            $ex taskset -c 2 $wrap $(pwd)/$t/build/compiler measure-compile --runs 41 --reference /usr/bin/tcc -- -c harness/hello.c > $log/hello-$cond-$t-$round.txt 2>&1
        done
    done
done
for cond in always disabled; do
    wrap=""
    [ $cond = disabled ] && wrap=harness/nothp
    $ex taskset -c 2 $wrap harness/best_of objects-$log/best_of.o 3 $(pwd)/$base/build/compiler $(pwd)/$head/build/compiler /usr/bin/tcc < $log/subset.list > $log/c-testsuite-$cond.txt 2>&1
done
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
for t in $base $head; do
    $ex taskset -c 2 $t/build/compiler measure-compile --runs 11 --reference /usr/bin/tcc -- "${options[@]}" > $log/sqlite-$t.txt 2>&1
    $ex taskset -c 2 $t/build/compiler "${options[@]}" -o objects-$log/sqlite3.$t.o >> $log/sqlite-$t.txt 2>&1
done
cmp objects-$log/sqlite3.$base.o objects-$log/sqlite3.$head.o > $log/sqlite-objects.txt 2>&1 && echo "sqlite3.o identical" >> $log/sqlite-objects.txt
echo done > $log/DONE
