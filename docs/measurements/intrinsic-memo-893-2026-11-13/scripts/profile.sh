#!/bin/bash
# profile.sh WORKLOAD BUILD (inside one hold): a cycles:u profile of BUILD (base or head) on CPU 2, the samples by
# symbol. sqlite is 10 compiles of sqlite3.c in turn, musl one of musl's command, cts 10 of c-testsuite's command.
set -u
cd "$(dirname "$0")"
. ./common.sh
workload=$1
build=$2
c=$base
if [[ $build == head ]]; then c=$head; fi
out=$here/results/profile
mkdir -p "$out"
head -1 /var/lib/buster-9700x/owner > "$out/$workload-$build-holder.txt"
case $workload in
    sqlite) dir=$t/s/$build; n=10; args="-c $ct $sqlite/sqlite3.c -o $t/o/p.o" ;;
    musl) dir=$t/m/$build; n=1; args="$mo --lanes 1 -c @$t/lists/musl.txt" ;;
    cts) dir=$t/c/$build; n=10; args="--lanes 1 -c @$t/lists/cts.txt" ;;
    *) echo "profile.sh: no workload $workload" >&2; exit 2 ;;
esac
cd "$dir" && taskset -c 5 perf record -q -o $t/o/$workload-$build.data -e cycles:u -c 20011 -- \
    taskset -c 2 bash -c 'for ((i = 0; i < '$n'; i += 1)); do "$0" '"$args"' > /dev/null 2>&1 || exit 1; done' "$c"
status=$?
perf report -i $t/o/$workload-$build.data --no-children --sort sym --stdio -q --percent-limit 0.05 > "$out/$workload-$build.txt" 2> "$out/$workload-$build.log"
perf report -i $t/o/$workload-$build.data --no-children --sort sym --stdio -q -F overhead,sample,sym 2>/dev/null | \
    grep -E "intrinsic|memcmp|memset_avx|total" > "$out/$workload-$build-focus.txt"
perf report -i $t/o/$workload-$build.data --no-children --stdio -q --sort dso -F sample 2>/dev/null | awk '{s+=$1} END {print "samples " s}' >> "$out/$workload-$build-focus.txt"
rm -f $t/o/$workload-$build.data
cat "$out/$workload-$build-focus.txt"
exit $status
