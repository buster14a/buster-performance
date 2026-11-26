#!/bin/bash
# ifparse.sh: per-function IBS fetch statistics (samples, op cache misses, I-cache misses, fetch latency) of base and work.
cd ~/buster-fast-bench/3577-claude || exit 1
for t in base work; do
  nm -n --defined-only $t/build/compiler | awk '$2 ~ /^[tTwW]$/ {print $1, $3}' > if-syms-$t.txt
  perf report -D -i pif-$t.data 2>/dev/null | awk '
    /^ibs_fetch_ctl:/ { for (i = 2; i <= NF; i++) { if ($i == "Lat") lat = $(i+1); if ($i == "Comp") comp = $(i+1); if ($i == "IcMiss") ic = $(i+1); if ($i == "FetchOcMiss") oc = $(i+1); if ($i == "L1TlbMiss") tlb = $(i+1) } have = 1; next }
    /^IbsFetchLinAd:/ { if (have) { printf "%s %s %s %s %s %s\n", $2, lat, comp, ic, oc, tlb; have = 0 } }' > if-samples-$t.txt
  awk -v T=$t 'NR == FNR { a[n] = strtonum("0x" $1); s[n] = $2; n++; next }
    { x = strtonum("0x" $1); lo = 0; hi = n - 1; if (x < a[0]) { f = "?" } else { while (lo < hi) { mid = int((lo + hi + 1) / 2); if (a[mid] <= x) lo = mid; else hi = mid - 1 } f = s[lo] }
      N[f]++; L[f] += $2; C[f] += $3; I[f] += $4; O[f] += $5; tot++; tI += $4; tO += $5; tL += $2 }
    END { printf "TOTAL\t%s\t%d\t%d\t%d\t%d\n", T, tot, tI, tO, tL; for (f in N) printf "F\t%s\t%s\t%d\t%d\t%d\t%d\n", T, f, N[f], I[f], O[f], L[f] }' if-syms-$t.txt if-samples-$t.txt
done > if-sum.txt
grep TOTAL if-sum.txt
echo "delta_ic delta_oc delta_lat | base: n ic oc lat | work: n ic oc lat | function"
awk -F'\t' '$1=="F"{k=$3; if ($2=="base") {bn[k]=$4; bi[k]=$5; bo[k]=$6; bl[k]=$7} else {wn[k]=$4; wi[k]=$5; wo[k]=$6; wl[k]=$7}; seen[k]=1}
  END {for (k in seen) printf "%d\t%d\t%d\t| %d %d %d %d | %d %d %d %d | %s\n", wi[k]-bi[k], wo[k]-bo[k], wl[k]-bl[k], bn[k], bi[k], bo[k], bl[k], wn[k], wi[k], wo[k], wl[k], k}' if-sum.txt | sort -t$'\t' -k3,3gr | head -40
