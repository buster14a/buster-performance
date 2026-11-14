#!/bin/bash
# annotate.sh BUILD [TREE] (inside one hold): 20 compiles of sqlite3.c by BUILD (base, head, or TREE's compiler) on
# CPU 2 under a cycles:u profile (period 200,003, below perf's throttle), then check_input_intrinsic_initialize's
# annotated instructions and the profile's lines for it.
set -u
cd "$(dirname "$0")"
. ./common.sh
build=$1
c=$base
if [[ $build == head ]]; then c=$head; fi
if [[ -n ${2:-} ]]; then c=$here/$2/build/compiler; build=$2; fi
out=$here/results/annotate
mkdir -p "$out"
head -1 /var/lib/buster-9700x/owner > "$out/$build-holder.txt"
data=$t/o/annotate-$build.data
(cd $t/s/base && taskset -c 5 perf record -q -o $data -e cycles:u -c 200003 -- \
    taskset -c 2 bash -c 'for ((i = 0; i < 20; i += 1)); do "$0" -c '"$ct $sqlite/sqlite3.c"' -o '$t'/o/a.o > /dev/null 2>&1 || exit 1; done' "$c")
status=$?
perf report -i $data --no-children --sort sym --stdio -q -F overhead,sample,sym 2>/dev/null | grep -E "intrinsic|memcmp|memset_avx" > "$out/$build-focus.txt"
perf report -i $data --no-children --stdio -q --sort dso -F sample 2>/dev/null | awk '{s+=$1} END {print "samples " s}' >> "$out/$build-focus.txt"
perf annotate -i $data --stdio -s check_input_intrinsic_initialize.buster_split 2> /dev/null | grep -v "^\s*0.00 :" | head -400 > "$out/$build-annotate.txt"
rm -f $data
cat "$out/$build-focus.txt"
exit $status
