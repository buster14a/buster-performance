#!/bin/bash
# probe.sh NAME RUNS INPUT...: the producer's phases (fs-probe, TSC ticks) and the merge-strings stage of RUNS
# link-foreign --merge-strings processes of each INPUT by probe-main's and probe-fix's Release executables in turn,
# pinned to CPU 2, under the 9700X's lock (#3261's attribution; the probes are not in the branch).
D=~/buster-fast-bench/3044-claude
name=$1; runs=$2; shift 2
cd $D/inputs
for input in "$@"; do
    args=$(awk -v n="$input" '$1 == n {$1 = ""; print}' $D/inputs.txt)
    for r in $(seq 1 $runs); do
        for t in ${TREES:-probe-main probe-fix}; do
            line=$(BUSTER_FS_PROBE=1 taskset -c 2 $D/$t/build/compiler link-foreign --merge-strings --time --lanes 1 -o $D/out/probe $args 2>&1 | awk '/^fs-probe/ {p = $0} $1 == "merge-strings" {m = $2} END {print m, p}')
            echo "$input $t $line" >> $D/results/$name-probe.txt
        done
    done
done
