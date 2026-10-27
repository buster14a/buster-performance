#!/bin/bash
# #530's A/B on the 9700X: base (373ce21b) against head3 (0b5af444), under the shared lock, pinned to CPU 2.
set -u
cd ~/buster-fast-bench/perf-530-claude
export EXCLUSIVE_OWNER=claude-530 EXCLUSIVE_TITLE="#530 checker graph/program passes A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/530
lock=~/buster-fast-bench/exclusive.sh
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
quoted=$(printf '%q ' "${options[@]}")
echo "start $(date -Is)"
if [ ! -x head3/build/compiler ]; then
    (cd head3 && BUSTER_DEBUG_INFO=0 $lock ./build.sh) > build-head3.log 2>&1 || { echo "build head3 failed"; tail -5 build-head3.log; exit 1; }
    tail -1 build-head3.log
fi
$lock bash -c "taskset -c 2 base/build/compiler $quoted -o base.o && taskset -c 2 head3/build/compiler $quoted -o head3.o && taskset -c 2 head3/build/compiler --scalar $quoted -o head3-scalar.o"
cmp base.o head3.o && cmp base.o head3-scalar.o && echo "objects identical: $(sha256sum head3.o | cut -c1-16)"
: > stages3.txt
for hold in 1 2 3; do
    $lock bash -c "for round in 1 2 3 4 5; do order='base head3'; [ \$(( (round + $hold) % 2 )) -eq 0 ] && order='head3 base'; for tree in \$order; do taskset -c 2 \$tree/build/compiler --time-stages $quoted -o /dev/null 2>&1 | sed \"s/^/\$tree /\"; done; done" >> stages3.txt
done
echo "stages done $(date -Is)"
for tree in base head3; do
    $lock taskset -c 2 perf stat -r 11 -e task-clock,cycles:u,instructions:u,branch-misses:u -o stat3-$tree.txt -- $tree/build/compiler "${options[@]}" -o /dev/null
done
echo "stat done $(date -Is)"
: > graph3.txt
for round in 1 2; do
    for tree in base head3; do
        $lock taskset -c 2 $tree/build/compiler benchmark-checker-source --passes 11 --only vector "${options[@]:1}" 2>&1 | grep -E "body_graph|comparison" | sed "s/^/$tree $round /" >> graph3.txt
    done
done
echo "done $(date -Is)"
