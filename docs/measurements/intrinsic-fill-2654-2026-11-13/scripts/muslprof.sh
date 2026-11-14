#!/bin/bash
# muslprof.sh BUILD [TREE] (inside one hold): 3 runs of musl's 1,336-unit command by BUILD (base, head, or TREE's
# compiler, named TREE) on CPU 2 under a
# cycles:u profile (period 200,003, below perf's throttle); the intrinsic set-up's functions, memcmp and memset.
set -u
cd "$(dirname "$0")"
. ./common.sh
build=$1
c=$base
if [[ $build == head ]]; then c=$head; fi
if [[ -n ${2:-} ]]; then c=$here/$2/build/compiler; build=$2; mkdir -p $t/m/$2; fi
out=$here/results/muslprof
mkdir -p "$out"
data=$t/o/muslprof-$build.data
(cd $t/m/$build && taskset -c 5 perf record -q -o $data -e cycles:u -c 200003 -- \
    taskset -c 2 bash -c 'for ((i = 0; i < 3; i += 1)); do "$0" '"$mo"' --lanes 1 -c @'$t'/lists/musl.txt > /dev/null 2>&1 || exit 1; done' "$c")
status=$?
perf report -i $data --no-children --sort sym --stdio -q -F overhead,sample,sym 2>/dev/null | grep -E "intrinsic|memcmp|memset_avx" > "$out/$build-focus.txt"
perf report -i $data --no-children --stdio -q --sort dso -F sample 2>/dev/null | awk '{s+=$1} END {print "samples " s}' >> "$out/$build-focus.txt"
rm -f $data
cat "$out/$build-focus.txt"
exit $status
