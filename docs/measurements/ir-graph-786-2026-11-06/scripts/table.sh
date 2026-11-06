#!/bin/bash
# 786-claude: a markdown table of parse.sh's rows: for each row, each tree's median over placements of its per-placement
# medians over rounds, with their spread (largest over smallest), and the head's paired ratio to each reference at the
# same placement: its median and range over placements.
#   ./table.sh ROWS.tsv OLD MAIN HEAD
rows=$1 old=$2 main=$3 head=$4
awk -v old="$old" -v main="$main" -v head="$head" -F'\t' '
function median(list, n,    i, j, t, sorted) {
    for (i = 1; i <= n; i++) sorted[i] = list[i]
    for (i = 2; i <= n; i++) { t = sorted[i]; for (j = i - 1; j >= 1 && sorted[j] > t; j--) sorted[j + 1] = sorted[j]; sorted[j + 1] = t }
    return n % 2 ? sorted[(n + 1) / 2] : (sorted[n / 2] + sorted[n / 2 + 1]) / 2
}
function summary(tree, row,    s, n, r, list, per, lo, hi, i) {
    n = 0
    for (s in shifts) {
        key = tree SUBSEP s SUBSEP row
        if (count[key] == 0) continue
        delete list; for (r = 1; r <= count[key]; r++) list[r] = value[key, r]
        m[tree, s] = median(list, count[key]); n++; per[n] = m[tree, s]
    }
    if (n == 0) return "– | –"
    lo = per[1]; hi = per[1]; for (i = 2; i <= n; i++) { lo = per[i] < lo ? per[i] : lo; hi = per[i] > hi ? per[i] : hi }
    return sprintf("%.3f | %.1f%%", median(per, n), (hi / lo - 1) * 100)
}
function ratio(reference, row,    s, k, list, lo, hi, i) {
    k = 0
    for (s in shifts) if ((head, s) in m && (reference, s) in m) { k++; list[k] = m[head, s] / m[reference, s] }
    if (k == 0) return "–"
    lo = list[1]; hi = list[1]; for (i = 2; i <= k; i++) { lo = list[i] < lo ? list[i] : lo; hi = list[i] > hi ? list[i] : hi }
    return sprintf("%+.1f%% [%+.1f%%, %+.1f%%]", (median(list, k) - 1) * 100, (lo - 1) * 100, (hi - 1) * 100)
}
{ key = $1 SUBSEP $2 SUBSEP $4; count[key]++; value[key, count[key]] = $5; shifts[$2] = 1; if (!($4 in seen)) { seen[$4] = 1; order[++rows] = $4 } }
END {
    printf "| Row | Old | Spread | Main | Spread | Head | Spread | Head/old | Head/main |\n| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |\n"
    for (i = 1; i <= rows; i++) {
        row = order[i]; delete m
        o = summary(old, row); a = summary(main, row); h = summary(head, row)
        printf "| %s | %s | %s | %s | %s | %s |\n", row, o, a, h, ratio(old, row), ratio(main, row)
    }
}' "$rows"
