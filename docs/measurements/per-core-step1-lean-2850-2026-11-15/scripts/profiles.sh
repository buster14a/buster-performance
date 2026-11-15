#!/bin/bash
# profiles.sh LABEL PASSES VARIANT...: profile.sh's three profiles (cycles, instructions, mispredicted branches) of
# each VARIANT (whole, lean, loads) of LABEL's kernel on sqlite3.c with the windows packed, PASSES passes a run, each
# kept under the variant's name: results/LABEL/profile-EVENT-VARIANT.txt, profile-run-EVENT-VARIANT.txt and
# profile-summary-VARIANT-EVENT.txt. A kernel's part has a few hundred samples at 40 passes, which reads its cycles to
# a tenth or a fifth; the record's tables are from 160.
cd "$(dirname "$0")"
label=$1
passes=$2
shift 2
for variant in "$@"; do
    option=--facts-$variant
    if [ "$variant" = whole ]; then option=; fi
    for event in "cycles 200003" "instructions 400009" "branch-misses 1009"; do
        name=${event% *}
        period=${event#* }
        ./profile.sh "$label" $passes $name $period $option --facts-packed > results/$label/profile-summary-$variant-$name.txt 2>&1
        for f in profile-$name.txt profile-$name.log profile-run-$name.txt; do mv results/$label/$f results/$label/${f%.*}-$variant.${f##*.}; done
        rm -f results/$label/perf-$name.data
    done
done
echo profiles-done
