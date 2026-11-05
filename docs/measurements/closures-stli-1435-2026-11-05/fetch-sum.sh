#!/usr/bin/env bash
# fetch-sum A.tsv B.tsv: IBS fetch samples of two builds by function: samples, op cache misses, IC misses, ITLB misses,
# and the completed fetches' total latency; sorted by B's op cache misses less A's.
set -u
awk '
FNR == 1 { f++ }
$7 ~ /^lua-/ || $7 ~ /libc/ { s = $1; sub(/\+0x[0-9a-f]*$/, "", s); n[f, s]++; names[s] = 1; tot[f]++
  oc[f, s] += $5; ic[f, s] += $4; tl[f, s] += $6; if ($2 == 1) lat[f, s] += $3; toc[f] += $5; tic[f] += $4; tlat[f] += ($2 == 1 ? $3 : 0) }
END {
  printf "%-28s %7s %7s %6s %6s %5s %5s %4s %4s %8s %8s\n", "function", "n-A", "n-B", "oc-A", "oc-B", "ic-A", "ic-B", "tl-A", "tl-B", "lat-A", "lat-B"
  printf "%-28s %7d %7d %6d %6d %5d %5d %4s %4s %8d %8d\n", "TOTAL", tot[1], tot[2], toc[1], toc[2], tic[1], tic[2], "", "", tlat[1], tlat[2]
  for (s in names) printf "%-28s %7d %7d %6d %6d %5d %5d %4d %4d %8d %8d %d\n", s, n[1, s], n[2, s], oc[1, s], oc[2, s], ic[1, s], ic[2, s], tl[1, s], tl[2, s], lat[1, s], lat[2, s], oc[2, s] - oc[1, s] | "sort -k12,12nr | head -25"
}' $1 $2
