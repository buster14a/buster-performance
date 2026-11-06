#!/bin/bash
# #868: from collect.sh's TSV (standard input), each input's and offset's medians over the rounds by variant, and the
# paired differences (fragments on minus off, the same round and offset): their median, range and how many are above 0.
set -euo pipefail
tsv=$(cat)
median() { sort -g | awk '{ a[NR] = $1 } END { if (NR % 2) print a[(NR + 1) / 2]; else printf "%.3f\n", (a[NR / 2] + a[NR / 2 + 1]) / 2 }'; }
for input in sqlite lua; do
    for col in lower:5 statements:6 span:7 wall:8; do
        name=${col%%:*}; c=${col##*:}
        for off in 0 2048 all; do
            sel() { awk -F'\t' -v i="$input" -v o="$off" -v v="$1" -v c="$c" 'NR > 1 && $4 == i && $3 == v && (o == "all" || $2 == o) { print $c }' <<< "$tsv"; }
            m_off=$(sel off | median); m_on=$(sel on | median)
            diffs=$(awk -F'\t' -v i="$input" -v o="$off" -v c="$c" 'NR > 1 && $4 == i && (o == "all" || $2 == o) { k = $1 "/" $2; if ($3 == "on") on[k] = $c; else off[k] = $c } END { for (k in on) if (k in off) printf "%.3f\n", on[k] - off[k] }' <<< "$tsv")
            n=$(wc -l <<< "$diffs"); up=$(awk '$1 > 0' <<< "$diffs" | wc -l)
            printf '%-6s %-10s offset %-4s off %8s  on %8s  on-off median %7s  range %7s to %7s  above 0: %d of %d\n' \
                "$input" "$name" "$off" "$m_off" "$m_on" "$(median <<< "$diffs")" "$(sort -g <<< "$diffs" | head -1)" "$(sort -g <<< "$diffs" | tail -1)" "$up" "$n"
        done
    done
    awk -F'\t' -v i="$input" 'NR > 1 && $4 == i && $1 == 1 { printf "%-6s coverage offset %s %s: batched %d of %d evaluated\n", i, $2, $3, $9, $10 }' <<< "$tsv"
done
