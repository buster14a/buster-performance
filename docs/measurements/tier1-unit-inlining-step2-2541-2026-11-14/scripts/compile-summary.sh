#!/bin/bash
# compile-summary.sh PERF.TSV: each name's median user cycles, instructions and task-clock over the measured rounds.
awk -F'\t' '$1 != 0 { n[$2]++; c[$2, n[$2]] = $4; i[$2, n[$2]] = $5; t[$2, n[$2]] = $3 }
function med(a, k, m,    x, y, z, v) { for (x = 1; x <= m; x++) v[x] = a[k, x]; for (x = 1; x <= m; x++) for (y = x + 1; y <= m; y++) if (v[y] < v[x]) { z = v[x]; v[x] = v[y]; v[y] = z } return m % 2 ? v[(m + 1) / 2] : (v[m / 2] + v[m / 2 + 1]) / 2 }
END { for (k in n) printf "%-8s cycles %8.1f M  instructions %8.1f M  task-clock %6.1f ms  (%d runs)\n", k, med(c, k, n[k]) / 1e6, med(i, k, n[k]) / 1e6, med(t, k, n[k]), n[k] }' "$1" | sort
