#!/bin/bash
# summary.sh FILE.tsv [BASE]: per input and build (an executable's name less its -SHIFT), the stage's median, its
# interquartile mean and its minimum in ms over every placement and round, and each build's median and interquartile
# mean against BASE's (main by default) for the same input.
base=${2:-main}
awk -F'\t' -v base="$base" '$5 != "fail" {n = $3; sub(/-[0-9]+$/, "", n); k = $2 "\t" n; v[k] = v[k] " " $5; inputs[$2] = 1; builds[n] = 1}
END {
  for (k in v) {
    c = split(substr(v[k], 2), a, " "); asort(a)
    med[k] = c % 2 ? a[(c + 1) / 2] : (a[c / 2] + a[c / 2 + 1]) / 2
    lo = int(c / 4) + 1; hi = c - int(c / 4); s = 0; for (i = lo; i <= hi; i++) s += a[i]; iqm[k] = s / (hi - lo + 1)
    cnt[k] = c; mn[k] = a[1]
  }
  for (i in inputs) for (b in builds) { k = i "\t" b; r = i "\t" base; if (k in med)
    printf "%-17s %-6s n %3d median %8.4f iqm %8.4f min %8.4f  vs %s: median %6.3f iqm %6.3f\n", i, b, cnt[k], med[k], iqm[k], mn[k], base, med[k] / med[r], iqm[k] / iqm[r] }
}' "$1" | sort
