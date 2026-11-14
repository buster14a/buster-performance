#!/bin/bash
# tally.sh DIR: each corpus's census totals from DIR/NAME.txt.
for c in sqlite main lua ct musl; do
awk -F'\t' -v c=$c '
{ for (i = 1; i <= NF; i++) { k = $i;
    if (k == "bodies" && !("walk" in seen)) {} }
  n = ""; for (i = 2; i <= NF; i++) {
    if ($i == "walk" || $i == "scan" || $i == "arms") { n = $i; continue }
    if (n == "" && i % 2 == 1 && $(i) ~ /^[a-z-]+$/ && $(i+1) ~ /^[0-9]+$/) top[$i] += $(i+1)
    if (n != "" && ($i == "differing" || $i == "unarmed" || $i == "missing" || $i == "extra-bodies" || $i == "extra-symbols" || $i == "ticks")) v[n, $i] += $(i+1)
    if (n != "" && $i == "selection") verdict[n, $(i+1)]++ } units++ }
END { printf "%s units %d bodies %d dropped %d selected-bodies %d selected-symbols %d references-ticks %d\n", c, units, top["bodies"], top["dropped"], top["selected-bodies"], top["selected-symbols"], top["references-ticks"];
  split("walk scan arms", ns, " ");
  for (j = 1; j <= 3; j++) { m = ns[j]; printf "  %s differing %d unarmed %d missing %d extra-bodies %d extra-symbols %d ticks-ratio %.2f |", m, v[m,"differing"], v[m,"unarmed"], v[m,"missing"], v[m,"extra-bodies"], v[m,"extra-symbols"], v[m,"ticks"] / top["references-ticks"];
    split("same-references same different failed none", vs, " "); for (q = 1; q <= 5; q++) if (verdict[m, vs[q]] > 0) printf " %s %d", vs[q], verdict[m, vs[q]]; print "" } }' "$1/$c.txt"
done
