#!/bin/bash
# #530's A/B against main a774acd2, repeated with the order balanced: the merge 2163d68a and head 1989a51d beside it,
# 15 rounds in three holds of the shared lock, pinned to CPU 2. Round r (1 to 15) runs the builds from index r mod 3 on,
# so that each build runs first, second and third in 5 rounds each. ab.sh, the first run, passed the hold's number as
# bash -c's $0, which left it unset inside the script; here the outer shell expands it into the script itself.
set -u
cd ~/buster-fast-bench/perf-530-claude
export EXCLUSIVE_OWNER=claude-530 EXCLUSIVE_TITLE="#530 checker passes A/B against main, balanced repeat" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/573
lock=~/buster-fast-bench/exclusive.sh
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
quoted=$(printf '%q ' "${options[@]}")
trees=(main-a774 merge-2163 head-1989)
echo "start $(date -Is)"
sha256sum main-a774/build/compiler merge-2163/build/compiler head-1989/build/compiler
$lock bash -c "for tree in ${trees[*]}; do taskset -c 2 \$tree/build/compiler $quoted -o balanced-\$tree.o && taskset -c 2 \$tree/build/compiler --scalar $quoted -o balanced-\$tree-scalar.o || exit 1; done"
same=1
for f in balanced-main-a774-scalar.o balanced-merge-2163.o balanced-merge-2163-scalar.o balanced-head-1989.o balanced-head-1989-scalar.o; do cmp balanced-main-a774.o $f || same=0; done
[ $same -eq 1 ] && echo "objects identical: $(sha256sum balanced-main-a774.o | cut -c1-16)"
: > stages5.txt
for hold in 1 2 3; do
    $lock bash -c "
        trees=(${trees[*]})
        for round in 1 2 3 4 5; do
            r=\$(( ($hold - 1) * 5 + round ))
            for k in 0 1 2; do
                tree=\${trees[\$(( (r + k) % 3 ))]}
                taskset -c 2 \$tree/build/compiler --time-stages $quoted -o /dev/null 2>&1 | sed \"s/^/\$tree /\"
            done
        done" >> stages5.txt
done
echo "stages done $(date -Is)"
# Each run's report starts with its header line; count each build's place in its round.
awk '$2 == "time-stage" && $3 == "stage" { place = n++ % 3; count[$1 " " place]++ } END { for (key in count) print "position", key, count[key] }' stages5.txt | sort
echo "done $(date -Is)"
