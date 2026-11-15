#!/bin/bash
# lean.sh LABEL REVISION PATCH [RUNS]: build LABEL from main REVISION with PATCH, then on the three corpora, each run
# its own hold of the lock, the three kernels (whole, lean, loads) with a body a window and with the windows packed to
# 384 records; then the lean and the loads' kernels' profiles on sqlite3.c, packed.
cd "$(dirname "$0")"
label=$1; revision=$2; patch=$3; runs=${4:-3}
./build-label.sh "$label" "$revision" "$patch" || exit 1
./facts.sh "$label" "" $runs --passes 5 --list 20
./facts.sh "$label" "-lean" $runs --facts-lean --passes 5 --list 20
./facts.sh "$label" "-loads" $runs --facts-loads --passes 5 --list 20
./facts.sh "$label" "-packed" $runs --facts-packed --passes 5 --list 20
./facts.sh "$label" "-leanpacked" $runs --facts-lean --facts-packed --passes 5 --list 20
./facts.sh "$label" "-loadspacked" $runs --facts-loads --facts-packed --passes 5 --list 20
for variant in lean loads; do
    for e in "cycles 200003" "instructions 400009" "branch-misses 1009"; do
        set -- $e
        ./profile.sh "$label" 40 $1 $2 --facts-$variant --facts-packed > results/$label/profile-summary-$variant-$1.txt 2>&1
        for f in profile-$1.txt profile-$1.log profile-run-$1.txt; do mv results/$label/$f results/$label/${f%.*}-$variant.${f##*.}; done
        rm -f results/$label/perf-$1.data
    done
done
echo lean-done
