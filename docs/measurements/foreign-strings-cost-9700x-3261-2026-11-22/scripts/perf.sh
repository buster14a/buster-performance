#!/bin/bash
# perf.sh TAG EXE INPUT RUNS: perf record (cycles, user, CPU 2) of RUNS link-foreign --merge-strings processes of INPUT
# (an inputs.txt name) by EXE, under the 9700X's lock alone; the report by symbol goes to perf/TAG-INPUT.txt (#3261).
set -u
D=~/buster-fast-bench/3044-claude
tag=$1; exe=$2; input=$3; runs=$4
args=$(awk -v n="$input" '$1 == n {$1 = ""; print}' $D/inputs.txt)
mkdir -p $D/${PERFDIR:-perf}
cd $D/inputs
perf record -q -e cycles:u -F 20000 -o $D/${PERFDIR:-perf}/$tag-$input.data -- taskset -c 2 bash -c "for i in \$(seq 1 $runs); do $exe link-foreign --merge-strings --lanes 1 -o $D/out/perf-$tag $args; done" > /dev/null 2>&1
perf report -i $D/${PERFDIR:-perf}/$tag-$input.data --no-children --sort sym --percent-limit 0.3 --stdio 2> /dev/null | grep -v '^#' | grep -v '^$' > $D/${PERFDIR:-perf}/$tag-$input.txt
