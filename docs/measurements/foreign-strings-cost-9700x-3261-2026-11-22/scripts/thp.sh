#!/bin/bash
# thp.sh EXE INPUT RUNS: huge-page faults (/proc/vmstat thp_fault_alloc), user and kernel cycles and page faults of RUNS
# link-foreign --merge-strings processes of INPUT, and of RUNS without --merge-strings (#3261; run under the lock).
D=~/buster-fast-bench/3044-claude
exe=$1; input=$2; runs=$3
args=$(awk -v n="$input" '$1 == n {$1 = ""; print}' $D/inputs.txt)
cd $D/inputs
for merge in --merge-strings --no-merge-strings; do
    before=$(awk '$1 == "thp_fault_alloc" {print $2}' /proc/vmstat)
    perf stat -x, -e cycles:u,cycles:k,page-faults -o $D/out/thp.stat -- bash -c "for i in \$(seq 1 $runs); do taskset -c 2 $exe link-foreign $merge --lanes 1 -o $D/out/thp $args 2> /dev/null; done"
    after=$(awk '$1 == "thp_fault_alloc" {print $2}' /proc/vmstat)
    echo "$(basename $(dirname $exe))/$(basename $exe) $input $merge thp_fault_alloc $((after - before)) $(grep -v '^#' $D/out/thp.stat | awk -F, 'NF > 2 {printf "%s %s ", $3, $1}')"
done
