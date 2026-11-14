#!/bin/bash
# Summarize the #1356 campaign: tier0 stage ms and default wall ms per point.
set -euo pipefail
work="$HOME/buster-fast-bench/1356-claude"
tail -n +2 "$work/samples.tsv" | while IFS=$'\t' read -r sample shape n report; do
    [ "$sample" = warmup ] && continue
    t=$(awk -F '\t' '$1 == "time-stage" && $2 == "tier0" { print $3 }' "$report")
    w=$(sed -n 's/^run 1 default: \([0-9.]*\) ms wall.*/\1/p' "$(dirname "$(dirname "$report")")/run.log")
    printf '%s\t%s\t%s\t%s\t%s\n' "$shape" "$n" "$sample" "$t" "$w"
done > "$work/summary-samples.tsv"
sort -t $'\t' -k1,1 -k2,2n -k4,4g "$work/summary-samples.tsv" | awk -F '\t' '
    { key = $1 "\t" $2; t[key, ++c[key]] = $4; w[key, c[key]] = $5; if (!(key in seen)) { seen[key] = 1; order[++k] = key } }
    END {
        print "shape\tn\tsamples\ttier0_median_ms\ttier0_min\ttier0_max\tns_per_case\twall_median_ms\twall_min\twall_max"
        for (i = 1; i <= k; i++) {
            key = order[i]; m = c[key]; split(key, a, "\t")
            # wall sorted separately
            for (j = 1; j <= m; j++) ws[j] = w[key, j]
            for (x = 1; x <= m; x++) for (y = x + 1; y <= m; y++) if (ws[y] + 0 < ws[x] + 0) { s = ws[x]; ws[x] = ws[y]; ws[y] = s }
            tm = t[key, int((m + 1) / 2)]
            printf "%s\t%s\t%d\t%.3f\t%.3f\t%.3f\t%.1f\t%.3f\t%.3f\t%.3f\n", a[1], a[2], m, tm, t[key, 1], t[key, m], tm * 1e6 / a[2], ws[int((m + 1) / 2)], ws[1], ws[m]
        }
    }' > "$work/summary.tsv"
cat "$work/summary.tsv"
awk -F '\t' 'NR > 1 { v[$1, $2] = $4; w[$1, $2] = $8 } END { for (s in shapes) ; split("switch label-table", sh, " "); for (i = 1; i <= 2; i++) printf "%s: tier0 4k->8k %.2fx, 8k->16k %.2fx; wall 4k->8k %.2fx, 8k->16k %.2fx\n", sh[i], v[sh[i], 8000] / v[sh[i], 4000], v[sh[i], 16000] / v[sh[i], 8000], w[sh[i], 8000] / w[sh[i], 4000], w[sh[i], 16000] / w[sh[i], 8000] }' "$work/summary.tsv" | tee "$work/ratios.txt"
