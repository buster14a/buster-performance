#!/usr/bin/env bash
# ibs-sum A.tsv B.tsv [T]: IBS op samples of two builds (ibs-parse's tsv) by function: ops sampled, loads, loads that hit
# L1 and took at least T cycles from tag to completion (default 20), and those loads' cycles beyond 5; then the 25
# instructions of each with the most such slow loads, with their data addresses' kind (stack 7fff..., other).
set -u
A=$1; B=$2; T=${3:-20}
fn() { echo "$1" | sed 's/+0x[0-9a-f]*$//'; }
awk -v T=$T '
FNR == 1 { f++ }
{ s = $1; sub(/\+0x[0-9a-f]*$/, "", s); ops[f, s]++; names[s] = 1; tot[f]++
  if ($2 == "L") { lds[f, s]++; if ($4 == 0 && $3 >= T) { slow[f, s]++; ex[f, s] += $3 - 5; slowt[f]++ } } }
END {
  printf "%-28s %8s %8s %7s %7s %8s %8s %9s %9s\n", "function", "ops-A", "ops-B", "ld-A", "ld-B", "slow-A", "slow-B", "excess-A", "excess-B"
  printf "%-28s %8d %8d %7s %7s %8d %8d\n", "TOTAL", tot[1], tot[2], "", "", slowt[1], slowt[2]
  for (s in names) printf "%-28s %8d %8d %7d %7d %8d %8d %9d %9d\n", s, ops[1, s], ops[2, s], lds[1, s], lds[2, s], slow[1, s], slow[2, s], ex[1, s], ex[2, s] | "sort -k7,7nr | head -30"
}' $A $B
for x in $A $B; do
    echo "== $x: instructions with the most slow L1-hit loads (>= $T cycles)"
    awk -v T=$T '$2 == "L" { n[$1]++; w[$1] = $5; if ($4 == 0 && $3 >= T) { s[$1]++; e[$1] += $3; st[$1] += ($6 ~ /^00007f/) } }
      END { for (i in s) printf "%-36s loads %5d slow %5d mean-slow %5.1f width %d stack %d\n", i, n[i], s[i], e[i] / s[i], w[i], st[i] }' $x | sort -k5,5nr | head -25
done
