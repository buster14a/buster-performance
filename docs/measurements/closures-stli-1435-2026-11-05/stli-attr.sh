#!/usr/bin/env bash
# stli-attr HIGH.tsv LOW.tsv [T]: one build's IBS op samples at a stack position of many STLI events (HIGH) and one of few
# (LOW). For each load instruction, the sampled loads that hit L1 and took at least T cycles (default 12) from tag to
# completion, at each; the 15 instructions whose slow loads grew most, with HIGH's data addresses (the low 12 bits) and
# the sampled stores of HIGH to the same 12 bits on another page (4 KiB aliases) or the same address (same page).
set -u
H=$1; Lo=$2; T=${3:-12}
awk -v T=$T '
FNR == 1 { f++ }
$2 == "L" { n[f, $1]++; if ($4 == 0 && $3 >= T) s[f, $1]++; names[$1] = 1 }
END { for (i in names) { d = s[1, i] - s[2, i]; if (d > 0) printf "%-36s loads %5d/%5d slow %5d/%5d grew %5d\n", i, n[1, i], n[2, i], s[1, i], s[2, i], d } }' $H $Lo | sort -k7,7nr | head -15 > /tmp/stli-attr-top.$$
cat /tmp/stli-attr-top.$$
echo "== their data addresses in HIGH and the stores that alias them"
for i in $(awk '{print $1}' /tmp/stli-attr-top.$$ | head -8); do
    awk -v I="$i" -v T=$T '
    FNR == NR { if ($1 == I && $2 == "L" && $4 == 0 && $3 >= T) { a[$6]++ } ; if ($2 == "S" && $6 != "0") { st[$6] = st[$6] " " $1 "/" $5 } ; next }
    END {
        for (x in a) { lo = substr(x, length(x) - 2); page = substr(x, 1, length(x) - 3); al = ""; same = ""
            for (y in st) { if (substr(y, length(y) - 2) == lo) { if (substr(y, 1, length(y) - 3) != page) al = al " " y ":" st[y]; else same = same " " st[y] } }
            printf "  %s slow-at %s x%d | same address:%s | 4K alias:%s\n", I, x, a[x], substr(same, 1, 160), substr(al, 1, 300) } }' $H $H | sort -t x -k2,2nr | head -4
done
rm -f /tmp/stli-attr-top.$$
