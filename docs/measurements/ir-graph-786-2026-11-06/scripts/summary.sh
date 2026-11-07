#!/bin/bash
# 786-claude: summarizes parse.sh's rows (tree, shift, round, row, ns). For each row and tree: the median over rounds
# at each placement, then those placements' minimum, median and maximum and their spread (max/min - 1); and for each
# tree after the first two, the median and range over placements of its paired ratio to each reference tree (the
# first two arguments: old and main), at the same placement.
#   ./summary.sh ROWS.tsv REFERENCE1 REFERENCE2 TREE...
rows=$1
shift
trees="$*"
awk -v trees="$trees" -F'\t' '
function median(list, n,    i, j, t, sorted) {
    for (i = 1; i <= n; i++) sorted[i] = list[i]
    for (i = 2; i <= n; i++) { t = sorted[i]; for (j = i - 1; j >= 1 && sorted[j] > t; j--) sorted[j + 1] = sorted[j]; sorted[j + 1] = t }
    return n % 2 ? sorted[(n + 1) / 2] : (sorted[n / 2] + sorted[n / 2 + 1]) / 2
}
{ key = $1 SUBSEP $2 SUBSEP $4; count[key]++; value[key, count[key]] = $5; shifts[$2] = 1; names[$4] = 1 }
END {
    tn = split(trees, tree, " ")
    for (row in names) {
        delete m
        printf "%s\n", row
        for (t = 1; t <= tn; t++) {
            n = 0
            for (s in shifts) {
                key = tree[t] SUBSEP s SUBSEP row
                if (count[key] == 0) continue
                delete list; for (r = 1; r <= count[key]; r++) list[r] = value[key, r]
                m[tree[t], s] = median(list, count[key])
                n++; per[n] = m[tree[t], s]
            }
            if (n == 0) continue
            lo = per[1]; hi = per[1]; for (i = 2; i <= n; i++) { lo = per[i] < lo ? per[i] : lo; hi = per[i] > hi ? per[i] : hi }
            printf "  %-6s median %9.3f  min %9.3f  max %9.3f  spread %5.1f%%  (%d placements)", tree[t], median(per, n), lo, hi, (hi / lo - 1) * 100, n
            for (ref = 1; ref <= 2 && t > 2; ref++) {
                k = 0
                for (s in shifts) if ((tree[t], s) in m && (tree[ref], s) in m) { k++; ratio[k] = m[tree[t], s] / m[tree[ref], s] }
                if (k == 0) continue
                rlo = ratio[1]; rhi = ratio[1]; for (i = 2; i <= k; i++) { rlo = ratio[i] < rlo ? ratio[i] : rlo; rhi = ratio[i] > rhi ? ratio[i] : rhi }
                printf "  vs %s %+6.1f%% [%+6.1f%%, %+6.1f%%]", tree[ref], (median(ratio, k) - 1) * 100, (rlo - 1) * 100, (rhi - 1) * 100
            }
            printf "\n"
        }
    }
}' "$rows" | awk 'BEGIN { RS = ""; FS = "\n" } { print }'
