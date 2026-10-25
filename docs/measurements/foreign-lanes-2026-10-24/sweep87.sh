#!/bin/bash
# One round of #87's lane sweep of the complete foreign link: for each lane count given, 11 links of synth's shape (the
# objects benchmark-link kept for #86's record, its command) with --time, pinned to the first N CPUs of
# 2,0,1,3,4,5,6,7, one per core, then their SMT siblings 8,9,11,12,13,14,15 (CPU 10 is offline).
base=~/buster-fast-bench/claude-linker-80
C=$base/tree87/build/compiler
out=/tmp/claude-linker-80-lanes; mkdir -p $out
cmd=$(sed "s#-o [^ ]*foreign.out#-o $out/foreign.out#" $base/logs2/foreign-command.txt)
cpus=(2 0 1 3 4 5 6 7 8 9 11 12 13 14 15)
for n in "$@"; do
    list=$(IFS=,; echo "${cpus[*]:0:$n}")
    for i in $(seq 11); do
        echo "== lanes $n run $i cpus $list"
        taskset -c $list $C link-foreign --time --lanes=$n $cmd || exit 1
    done
done
$out/foreign.out > /dev/null; echo "run=$?"
