#!/bin/bash
# pstat.sh NAME TREE...: perf stat (page faults, user instructions and cycles) of 200 link-foreign --merge-strings
# processes of each input by each tree's Release executable (shift 0), and of the same without --merge-strings, each
# tree and input under the 9700X's lock alone (#3261).
set -u
D=~/buster-fast-bench/3044-claude
name=$1; shift
export EXCLUSIVE_OWNER=claude-3261 EXCLUSIVE_TITLE='PR sweep: #3261 foreign strings cost' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3261
mkdir -p $D/results
for input in ${INPUTS:-duplicate-4096 unique-4096 lengths-4096 lengths-131072 br}; do
    args=$(awk -v n="$input" '$1 == n {$1 = ""; print}' $D/inputs.txt)
    for t in "$@"; do
        for merge in --merge-strings --no-merge-strings; do
            echo "== $t $input $merge" >> $D/results/$name-pstat.txt
            (cd $D/inputs && ~/buster-fast-bench/exclusive.sh perf stat -x, -e page-faults,instructions:u,cycles:u -r ${RUNS:-200} taskset -c 2 $D/shifts/$t/compiler-0 link-foreign $merge --lanes 1 -o $D/out/pstat-$t $args) 2>&1 | grep -v '^exclusive.sh\|^  title\|^  link' >> $D/results/$name-pstat.txt
        done
    done
done
echo "pstat $name done"
