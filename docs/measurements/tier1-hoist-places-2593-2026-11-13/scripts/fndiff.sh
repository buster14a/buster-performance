#!/usr/bin/env bash
# fndiff.sh A.tsv[,..] B.tsv[,..] [N]: per-function instruction totals (gap's kind rows), B - A, the N largest changes.
n=${3:-25}
sum() { local IFS=,; for f in $1; do cat "$f"; done | awk -F'\t' '$1 !~ /^#/ { c[$1] += $4 } END { for (k in c) print k "\t" c[k] }'; }
join -t$'\t' -a1 -a2 -e0 -o0,1.2,2.2 <(sum "$1" | sort) <(sum "$2" | sort) | awk -F'\t' '{ d = $3 - $2; if (d != 0) printf "%12d\t%12d\t%12d\t%s\n", d, $2, $3, $1 }' | sort -k1,1n | awk -v n=$n '{ a[NR] = $0 } END { for (i = 1; i <= NR && i <= n; i++) print a[i]; print "..."; for (i = (NR - n + 1 > n ? NR - n + 1 : n + 1); i <= NR; i++) print a[i] }'
