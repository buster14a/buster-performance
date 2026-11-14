#!/bin/bash
# tally.sh DIR: each corpus's census totals from DIR/NAME.txt (a line a unit: its name, the census's counts' line and its
# ticks' line, tab-joined): per census the differing, unarmed and missing bodies, the extra bodies and symbols and the
# verdicts; then the ticks' sums against the references pass's.
for c in sqlite main lua ct musl; do
    [ -f "$1/$c.txt" ] || continue
    awk -F'\t' -v c=$c '
    {
        units++; n = ""; ticks = 0
        for (i = 2; i <= NF; i++) {
            if ($i == "selection-census-ticks") { ticks = 1; continue }
            if (ticks) { if ($(i+1) ~ /^[0-9]+$/) { t[$i] += $(i+1); i++ } continue }
            if ($i == "walk" || $i == "scan" || $i == "arms" || $i == "pass") { n = $i; continue }
            if (n == "" && $(i+1) ~ /^[0-9]+$/ && $i != "selection-census") { top[$i] += $(i+1); i++; continue }
            if (n != "" && ($i == "differing" || $i == "unarmed" || $i == "missing" || $i == "extra-bodies" || $i == "extra-symbols")) v[n, $i] += $(i+1)
            if (n != "" && $i == "selection") verdict[n, $(i+1)]++
        }
    }
    END {
        printf "%s units %d bodies %d dropped %d selected-bodies %d selected-symbols %d\n", c, units, top["bodies"], top["dropped"], top["selected-bodies"], top["selected-symbols"]
        split("walk scan arms pass", ns, " ")
        for (j = 1; j <= 4; j++) {
            m = ns[j]
            printf "  %s differing %d unarmed %d missing %d extra-bodies %d extra-symbols %d ticks/references %.2f |", m, v[m,"differing"], v[m,"unarmed"], v[m,"missing"], v[m,"extra-bodies"], v[m,"extra-symbols"], t["references"] ? t[m] / t["references"] : 0
            split("same-references same different failed none", vs, " ")
            for (q = 1; q <= 5; q++) if (verdict[m, vs[q]] > 0) printf " %s %d", vs[q], verdict[m, vs[q]]
            print ""
        }
    }' "$1/$c.txt"
done
