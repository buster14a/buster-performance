#!/bin/bash
# profile.sh NAME TREE...: for each tree's Release executable (shift 0), perf.sh's profiles of 1,000 processes of
# duplicate-4096, unique-4096, lengths-4096 and br, then benchmark-foreign-strings in process (merge-vector, 51 runs)
# for duplicate and unique at 4,096 and 131,072; each run under the 9700X's lock alone (#3261).
set -u
D=~/buster-fast-bench/3044-claude
name=$1; shift
export EXCLUSIVE_OWNER=claude-3261 EXCLUSIVE_TITLE='PR sweep: #3261 foreign strings cost' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3261
mkdir -p $D/results
for input in ${INPUTS:-duplicate-4096 unique-4096 lengths-4096 br}; do
    for t in "$@"; do
        ~/buster-fast-bench/exclusive.sh $D/perf.sh $t $D/shifts/$t/compiler-0 $input ${RUNS:-1000} 2>> $D/results/$name.lock
    done
done
for shape in ${SHAPES:-duplicate unique}; do
    for t in "$@" "$@"; do
        echo "== $t $shape" >> $D/results/$name-inproc.txt
        ~/buster-fast-bench/exclusive.sh taskset -c 2 $D/shifts/$t/compiler-0 benchmark-foreign-strings --only $shape --counts 4096,131072 --runs 51 --order merge-vector >> $D/results/$name-inproc.txt 2>> $D/results/$name.lock
    done
done
echo "profile $name done"
