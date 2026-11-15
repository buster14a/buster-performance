#!/bin/bash
# summarize.sh RESULTS: per workload, each build's median total, check-program, user instructions and cycles over the rounds, and head/base.
set -u
awk -F'\t' 'NR > 1 && $4 == 0 { key = $2 "\t" $3; n[key]++; t[key, n[key]] = $6; c[key, n[key]] = $7; i[key, n[key]] = $8; y[key, n[key]] = $9; seen[$2] = 1; order[$2] = order[$2] ? order[$2] : NR }
function median(arr, key, count,    v, k, j, tmp) {
    for (k = 1; k <= count; k++) v[k] = arr[key, k] + 0
    for (k = 2; k <= count; k++) { tmp = v[k]; j = k - 1; while (j >= 1 && v[j] > tmp) { v[j + 1] = v[j]; j-- } v[j + 1] = tmp }
    return count % 2 ? v[(count + 1) / 2] : (v[count / 2] + v[count / 2 + 1]) / 2
}
END {
    printf "| workload | base total ms | head total ms | head/base | base check-program ms | head check-program ms | base user instructions | head user instructions | rounds |\n"
    printf "| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |\n"
    for (w in seen) list[order[w]] = w
    m = asort(list)
    for (k = 1; k <= m; k++) {
        w = list[k]; b = w "\tbase"; h = w "\thead"
        if (!n[b] || !n[h]) continue
        bt = median(t, b, n[b]); ht = median(t, h, n[h]); bc = median(c, b, n[b]); hc = median(c, h, n[h])
        bi = median(i, b, n[b]); hi = median(i, h, n[h])
        printf "| %s | %.1f | %.1f | %.3f | %.1f | %.1f | %.1f M | %.1f M | %d/%d |\n", w, bt, ht, ht / bt, bc, hc, bi / 1e6, hi / 1e6, n[b], n[h]
    }
}' "$1"
