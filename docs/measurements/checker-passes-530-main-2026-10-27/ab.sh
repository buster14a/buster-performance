#!/bin/bash
# #530's A/B against the current base on the 9700X: main a774acd2 against the merge 2163d68a and head 1989a51d, under the
# shared lock, pinned to CPU 2.
set -u
cd ~/buster-fast-bench/perf-530-claude
export EXCLUSIVE_OWNER=claude-530 EXCLUSIVE_TITLE="#530 checker passes A/B against main" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/573
lock=~/buster-fast-bench/exclusive.sh
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
quoted=$(printf '%q ' "${options[@]}")
trees=(main-a774 merge-2163 head-1989)
echo "start $(date -Is)"
for tree in "${trees[@]}"; do
    if [ ! -x $tree/build/compiler ]; then
        (cd $tree && BUSTER_DEBUG_INFO=0 $lock ./build.sh) > build-$tree.log 2>&1 || { echo "build $tree failed"; tail -5 build-$tree.log; exit 1; }
        tail -1 build-$tree.log
    fi
done
sha256sum */build/compiler | grep -E "main-a774|merge-2163|head-1989"
$lock bash -c "for tree in ${trees[*]}; do taskset -c 2 \$tree/build/compiler $quoted -o \$tree.o && taskset -c 2 \$tree/build/compiler --scalar $quoted -o \$tree-scalar.o || exit 1; done"
same=1
for f in main-a774-scalar.o merge-2163.o merge-2163-scalar.o head-1989.o head-1989-scalar.o; do cmp main-a774.o $f || same=0; done
[ $same -eq 1 ] && echo "objects identical: $(sha256sum main-a774.o | cut -c1-16)"
: > stages4.txt
for hold in 1 2 3; do
    $lock bash -c "trees=(${trees[*]}); for round in 1 2 3 4 5; do r=\$(( (hold - 1) * 5 + round )); for k in 0 1 2; do tree=\${trees[\$(( (r + k) % 3 ))]}; taskset -c 2 \$tree/build/compiler --time-stages $quoted -o /dev/null 2>&1 | sed \"s/^/\$tree /\"; done; done" hold=$hold >> stages4.txt
done
echo "stages done $(date -Is)"
for tree in "${trees[@]}"; do
    $lock taskset -c 2 perf stat -r 11 -e task-clock,cycles:u,instructions:u,branch-misses:u -o stat4-$tree.txt -- $tree/build/compiler "${options[@]}" -o /dev/null
done
echo "stat done $(date -Is)"
: > graph4.txt
for round in 1 2; do
    for tree in "${trees[@]}"; do
        $lock taskset -c 2 $tree/build/compiler benchmark-checker-source --passes 11 --only vector "${options[@]:1}" 2>&1 | grep -E "body_graph|comparison" | sed "s/^/$tree $round /" >> graph4.txt
    done
done
echo "done $(date -Is)"
