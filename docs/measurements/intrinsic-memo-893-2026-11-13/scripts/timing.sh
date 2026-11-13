#!/bin/bash
# timing.sh WORKLOAD RUNS [TREE] (inside one hold): time-runs of base and head (and TREE's compiler, as `other`) on CPU 2 in a Williams design's order, whole
# processes, with their user cycles and instructions. WORKLOAD is sqlite (-c sqlite3.c), musl (musl's 1,336 units as
# one command on one lane) or cts (c-testsuite's 220 units as one command on one lane).
set -u
cd "$(dirname "$0")"
. ./common.sh
workload=$1
runs=$2
other=()
if [[ -n ${3:-} ]]; then other=(--build other "$here/$3/build/compiler"); fi
out=$here/results/timing
mkdir -p "$out"
log=$out/$workload${3:+-$3}-copies${COPIES:-1}-$(date -u +%H%M%S).txt
mkdir -p $t/copies-time
head -1 /var/lib/buster-9700x/owner > "$log"
case $workload in
    sqlite) dir=$t/s/base; list=(-c $ct $sqlite/sqlite3.c -o $t/o/s.o) ;;
    musl) dir=$t/m/base; list=($mo --lanes 1 -c @$t/lists/musl.txt) ;;
    cts) dir=$t/c/base; list=(--lanes 1 -c @$t/lists/cts.txt) ;;
    *) echo "timing.sh: no workload $workload" >&2; exit 2 ;;
esac
cd "$dir" && taskset -c 2 "$base" time-runs --runs "$runs" --warmups 2 --copies "${COPIES:-1}" --directory $t/copies-time --build base "$base" --build head "$head" "${other[@]}" --list "${list[@]}" >> "$log" 2>&1
status=$?
echo "status $status" >> "$log"
cat "$log"
exit $status
