#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# #590 / buster14a/buster#1027 measurements on benchpress (Ryzen 7 9700X). Every build, compile and measurement takes the
# shared lock per run (exclusive.sh) and is pinned to CPU 2. Run from ~/buster-fast-bench/590-claude with base/ and head/
# built by `BUSTER_DEBUG_INFO=0 ./build.sh` under the lock.
set -u
cd ~/buster-fast-bench/590-claude
export EXCLUSIVE_OWNER=claude-590 EXCLUSIVE_TITLE="#590 backend setup measurements (PR #1027)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1027
ex=~/buster-fast-bench/exclusive.sh
log=logs
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
{
    date -u
    uname -a
    echo "THP enabled: $(cat /sys/kernel/mm/transparent_hugepage/enabled), defrag: $(cat /sys/kernel/mm/transparent_hugepage/defrag)"
    grep -m1 "model name" /proc/cpuinfo
    nproc
    sha256sum /usr/bin/tcc "$sqlite/sqlite3.c"
    tcc -v
    clang --version | head -1
    wild --version 2>&1 | head -1
    for t in base head; do echo "$t: $(git -C $t log -1 --format='%H %s')"; size $t/build/compiler; done
} > $log/host.txt 2>&1
# c-testsuite at the subset's commit
if [ ! -d c-testsuite/tests ]; then
    git init -q --template= c-testsuite && git -C c-testsuite fetch -q --depth 1 https://github.com/c-testsuite/c-testsuite 5c7275656d751de0e68b2d340a95b5681858ed07 && git -C c-testsuite checkout -q FETCH_HEAD
fi
sed -n 's|^\([0-9][0-9]*\)$|c-testsuite/tests/single-exec/\1.c|p' head/tests/c-testsuite/subset.txt > $log/subset.list
# Objects: both builds must write the same bytes.
mkdir -p objects
$ex bash -c 'd=0; n=0; while read f; do id=$(basename $f .c); base/build/compiler -c -o objects/$id.base.o $f 2>/dev/null; a=$?; head/build/compiler -c -o objects/$id.head.o $f 2>/dev/null; b=$?; n=$((n+1)); { [ $a = 0 ] && [ $b = 0 ] && cmp -s objects/$id.base.o objects/$id.head.o; } || { d=$((d+1)); echo "differs: $f ($a/$b)"; }; done < logs/subset.list; for f in harness/hello.c; do base/build/compiler -c -o objects/hello.base.o $f && head/build/compiler -c -o objects/hello.head.o $f && cmp objects/hello.base.o objects/hello.head.o || d=$((d+1)); done; echo "objects: $n c-testsuite programs and hello.c, $d differ"' > $log/objects.txt 2>&1
# hello.c, measure-compile against tcc: rounds alternate the builds' order; THP as the host has it (always) and disabled
# for the process and its children (PR_SET_THP_DISABLE, harness/nothp).
for round in 1 2 3; do
    if [ $((round % 2)) = 1 ]; then order="base head"; else order="head base"; fi
    for cond in always disabled; do
        wrap=""
        [ $cond = disabled ] && wrap=harness/nothp
        for t in $order; do
            $ex taskset -c 2 $wrap $(pwd)/$t/build/compiler measure-compile --runs 41 --reference /usr/bin/tcc -- -c harness/hello.c > $log/hello-$cond-$t-$round.txt 2>&1
        done
    done
done
# c-testsuite's subset: each program's best of 3 runs per build, in turn, summed (harness/best_of).
for cond in always disabled; do
    wrap=""
    [ $cond = disabled ] && wrap=harness/nothp
    $ex taskset -c 2 $wrap harness/best_of objects/best_of.o 3 $(pwd)/base/build/compiler $(pwd)/head/build/compiler /usr/bin/tcc < $log/subset.list > $log/c-testsuite-$cond.txt 2>&1
done
# sqlite3.c with the record's options (docs/compile-time.md), each build against tcc, and its objects compared.
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
for t in base head; do
    $ex taskset -c 2 $t/build/compiler measure-compile --runs 11 --reference /usr/bin/tcc -- "${options[@]}" > $log/sqlite-$t.txt 2>&1
    $ex taskset -c 2 $t/build/compiler "${options[@]}" -o objects/sqlite3.$t.o >> $log/sqlite-$t.txt 2>&1
done
cmp objects/sqlite3.base.o objects/sqlite3.head.o > $log/sqlite-objects.txt 2>&1 && echo "sqlite3.o identical" >> $log/sqlite-objects.txt
echo done > $log/DONE
