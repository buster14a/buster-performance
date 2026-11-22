# Medians of runs.tsv-like lines (extract2.awk) by list and build, over all placements and rounds, with the placements'
# medians' spread; each build against the first one given (BASE).
function median(a, n,    i, j, t) { for (i = 2; i <= n; i++) { t = a[i]; for (j = i - 1; j >= 1 && a[j] > t; j--) a[j + 1] = a[j]; a[j + 1] = t } return n % 2 ? a[(n + 1) / 2] : (a[n / 2] + a[n / 2 + 1]) / 2 }
{ key = $4 SUBSEP $2; for (c = 5; c <= 8; c++) { k = key SUBSEP c; cnt[k]++; v[k, cnt[k]] = $c; pk = k SUBSEP $3; pc[pk]++; pv[pk, pc[pk]] = $c; shifts[$3] = 1 } builds[$2] = 1; lists[$4] = 1 }
END {
    split("5 run 6 instructions 7 with-printing 8 printing", names, " ")
    for (l in lists) for (ci = 1; ci <= 8; ci += 2) {
        c = names[ci]; label = names[ci + 1]
        for (b in builds) {
            k = l SUBSEP b SUBSEP c; n = cnt[k]; if (n == 0) continue
            delete a; for (i = 1; i <= n; i++) a[i] = v[k, i]; m[b] = median(a, n)
            lo = 1e18; hi = 0
            for (s in shifts) { pk = k SUBSEP s; delete a; for (i = 1; i <= pc[pk]; i++) a[i] = pv[pk, i]; pm = median(a, pc[pk]); lo = pm < lo ? pm : lo; hi = pm > hi ? pm : hi }
            line[b] = sprintf("%s %s %s: %d runs, median %.3f; placements %.3f to %.3f (spread %.2f%%)", l, label, b, n, m[b], lo, hi, (hi / lo - 1) * 100)
        }
        for (b in builds) { r = line[b]; if (b != BASE && m[BASE] != 0) r = r sprintf("; against %s %+.2f%%", BASE, (m[b] / m[BASE] - 1) * 100); print r }
    }
}
