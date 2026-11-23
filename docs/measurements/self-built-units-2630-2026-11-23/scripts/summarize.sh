#!/bin/bash
# The campaign's tables from results/: build times (results/builds/results.tsv's `result` lines: mode, configuration,
# file, wall seconds, build.sh's line) as medians by tree, mode, file and configuration; the tests' wall seconds
# (results/tests/{off,tests}.tsv) as medians by command; time-runs' tables as they are in results/runtime.log.out.
set -u
d=${1:-$HOME/buster-fast-bench/2630-claude}
median() { sort -n | awk '{ v[NR] = $1 } END { if (NR == 0) { print "-" } else if (NR % 2) { print v[(NR + 1) / 2] } else { printf "%.3f\n", (v[NR / 2] + v[NR / 2 + 1]) / 2 } }'; }
echo "## Builds (wall s, medians; build.sh's 'the build took' in brackets)"
for tree in src lanes1; do
    f=$d/results/builds/$tree.log.out
    [ -f "$f" ] || continue
    grep '^result' "$f" | awk -F'\t' '{ print $2 "\t" $4 }' | sort -u | while IFS=$'\t' read -r mode file; do
        for cfg in off tests; do
            walls=$(grep '^result' "$f" | awk -F'\t' -v m="$mode" -v c="$cfg" -v x="$file" '$2 == m && $3 == c && $4 == x { print $5 }')
            took=$(grep '^result' "$f" | awk -F'\t' -v m="$mode" -v c="$cfg" -v x="$file" '$2 == m && $3 == c && $4 == x { if (match($6, /took [0-9.]+ s/)) print substr($6, RSTART + 5, RLENGTH - 7) }')
            [ -n "$walls" ] || continue
            printf '%s\t%s\t%s\t%s\tn=%s\t%s [%s]\n' "$tree" "$mode" "${file:--}" "$cfg" "$(echo "$walls" | wc -l)" "$(echo "$walls" | median)" "$(echo "$took" | median)"
        done
    done
done
echo
echo "## Tests (wall s, medians of the rounds)"
if [ -f "$d/results/tests/off.tsv" ]; then
    awk -F'\t' '{ print $3 }' "$d/results/tests/off.tsv" | awk '!seen[$0]++' | while IFS= read -r command; do
        row="$command"
        for name in off tests; do
            m=$(awk -F'\t' -v c="$command" '$3 == c { split($4, t, " "); print t[1] }' "$d/results/tests/$name.tsv" | median)
            rc=$(awk -F'\t' -v c="$command" '$3 == c { print $5 }' "$d/results/tests/$name.tsv" | sort -u | tr '\n' ' ')
            row="$row\t$m\t$rc"
        done
        printf '%b\n' "$row"
    done
fi
