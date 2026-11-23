#!/bin/bash
# summary.sh OUT: each configuration's medians over its passes, one worker and eight.
out=~/buster-fast-bench/2536-claude-kcl1ed/results/${1:?out}
for label in one eight; do
    echo "== $label: config  MB/s  wall-ms  user-Mcycles  kernel-Mcycles  instr-M  peak-MB  faults  pages  (passes)"
    for d in $(ls -d "$out"/*.1 | sed 's/\.1$//'); do
        name=$(basename "$d")
        cat "$d".[0-9]/whole.tsv | awk -v l=$label -v n=$name -F'\t' '$1==l { k++; mb[k]=$7; w[k]=$8; u[k]=$9/1e6; s[k]=$10/1e6; i[k]=$11/1e6; p[k]=$12/1024; f[k]=$13; hp=$15 }
            function med(a, n,   t, j) { for (j=1;j<=n;j++) t[j]=a[j]; asort(t); return n%2 ? t[(n+1)/2] : (t[n/2]+t[n/2+1])/2 }
            END { printf "%-14s %7.2f %8.3f %9.2f %8.2f %9.2f %7.1f %7d  %s (%d)\n", n, med(mb,k), med(w,k), med(u,k), med(s,k), med(i,k), med(p,k), med(f,k), hp, k }'
    done
done
tail -1 "$out/switch.txt"
