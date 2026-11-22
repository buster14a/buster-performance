#!/bin/bash
# insn.sh TAG EXE INPUT RUNS: user instructions and cycles by symbol (perf record, fixed periods), in thousands per
# process, of RUNS link-foreign --merge-strings processes of INPUT by EXE pinned to CPU 2 (#3261; run under the lock).
D=~/buster-fast-bench/3044-claude
tag=$1; exe=$2; input=$3; runs=$4
args=$(awk -v n="$input" '$1 == n {$1 = ""; print}' $D/inputs.txt)
mkdir -p $D/perf5
cd $D/inputs
for event in instructions:u cycles:u; do
    data=$D/perf5/$tag-$input-${event%:u}.data
    perf record -q -e $event -c 20011 -o $data -- taskset -c 2 bash -c "for i in \$(seq 1 $runs); do $exe link-foreign --merge-strings --lanes 1 -o $D/out/insn-$tag $args; done" > /dev/null 2>&1
    echo "== $tag $input $event"
    perf report -i $data --no-children --sort sym -F period,sym --stdio 2> /dev/null | grep -v '^#' | grep -i 'foreign_strings\|link_hash\|memset\|memcmp' | awk -v r=$runs '{printf "%10.1f k  %s\n", $1 / 1000 / r, $NF}'
done
