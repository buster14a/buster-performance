#!/bin/bash
# tally.sh DIR: from census.sh's DIR/NAME.txt and NAME.ticks, each corpus's units, those whose census is the same by BASE
# and HEAD, HEAD's pass census (differing, missing, extra bodies and symbols), the provisional selection's uses, extra
# symbols and objects the same bytes, and both compilers' pass ticks over their references pass's (sums over units). Then
# from repeat.sh's DIR/NAME.repeat.txt and NAME.SIDE.MODE.N.csv, per file: each side's medians of the references and
# pass ticks and of their ratio, and of -c's and --provisional-selection -c's task clock, user cycles and instructions.
dir=$1
median()
{
    sort -g | awk '{ v[NR] = $1 } END { if (NR % 2) print v[(NR + 1) / 2]; else print (v[NR / 2] + v[NR / 2 + 1]) / 2 }'
}
for c in sqlite main lua ct musl; do
    [ -f "$dir/$c.txt" ] || continue
    awk -F'\t' -v c=$c '
    {
        units++
        for (i = 2; i <= NF; i++) {
            if ($i == "pass") { pass = 1; continue }
            if ($i == "census same") same++
            if ($i == "objects same") objects++
            if ($i ~ /^provisional-selection/) { split($i, p, " "); used += p[3]; extra += p[5] }
            if (pass && ($i == "differing" || $i == "missing" || $i == "extra-bodies" || $i == "extra-symbols")) v[$i] += $(i+1)
            if (pass && $i == "selection" && $(i+1) == "different") off++
        }
        pass = 0
    }
    END {
        printf "%s units %d census-same %d pass: units-off %d differing %d missing %d extra-bodies %d extra-symbols %d provisional: used %d extra-symbols %d objects-same %d\n",
               c, units, same, off, v["differing"], v["missing"], v["extra-bodies"], v["extra-symbols"], used, extra, objects
    }' "$dir/$c.txt"
    awk -F'\t' -v c=$c '
    {
        side = ""
        for (i = 2; i <= NF; i++) {
            if ($i == "base" || $i == "head") { side = $i; continue }
            if ($(i+1) ~ /^[0-9]+$/) { t[side, $i] += $(i+1); i++ }
        }
    }
    END {
        printf "%s ticks: base pass/references %.3f (%d / %d), head %.3f (%d / %d)\n", c, t["base","pass"] / t["base","references"], t["base","pass"], t["base","references"],
               t["head","pass"] / t["head","references"], t["head","pass"], t["head","references"]
    }' "$dir/$c.ticks"
done
for f in sqlite main; do
    [ -f "$dir/$f.repeat.txt" ] || continue
    for side in base head; do
        r=$(awk -F'\t' -v s=$side '$1 == s { for (i = 3; i <= NF; i++) if ($i == "references") print $(i+1) }' "$dir/$f.repeat.txt" | median)
        p=$(awk -F'\t' -v s=$side '$1 == s { for (i = 3; i <= NF; i++) if ($i == "pass") print $(i+1) }' "$dir/$f.repeat.txt" | median)
        q=$(awk -F'\t' -v s=$side '$1 == s { for (i = 3; i <= NF; i++) { if ($i == "references") r = $(i+1); if ($i == "pass") p = $(i+1) } print p / r }' "$dir/$f.repeat.txt" | median)
        printf '%s %s: references %s ticks (%.3f ms), pass %s (%.3f ms), ratio median %.3f\n' "$f" "$side" "$r" "$(echo "$r / 3792500" | bc -l)" "$p" "$(echo "$p / 3792500" | bc -l)" "$q"
        for mode in plain provisional; do
            clock=$(cat "$dir/$f.$side.$mode".*.csv | awk -F, '$3 == "task-clock" { print $1 }' | median)
            cycles=$(cat "$dir/$f.$side.$mode".*.csv | awk -F, '$3 ~ /^cycles/ { print $1 }' | median)
            instructions=$(cat "$dir/$f.$side.$mode".*.csv | awk -F, '$3 ~ /^instructions/ { print $1 }' | median)
            printf '  %s %s: task clock %s ms, user cycles %s, user instructions %s\n' "$side" "$mode" "$clock" "$cycles" "$instructions"
        done
    done
done
