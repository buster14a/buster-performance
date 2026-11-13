#!/bin/bash
# The A/B's verdicts from results/bench/NAME.*.txt (bench.sh's reports), every benchmark or the NAMEs given:
# [CANDIDATE=NAME] analyze.sh [NAME...] > results/ab.txt
# CANDIDATE (head by default) selects bench.sh's reports of that candidate (NAME.TIME.CANDIDATE.txt for one other than
# the head).
# For each build, the median of its processes' user cycles and wall times over every run, placement and hold; each
# placement's median; the head's and base-again's medians against the base's, and each difference's range over the
# placements (each placement's median against each of the base's). The head is inside the floor when its range over
# the placements holds 0 and its difference is no larger than the largest of base-again's against the base over the
# placements (the base against itself, as #509's floors are read).
set -u
export LC_ALL=C
d=$HOME/buster-fast-bench/2559-release-claude
names=("$@")
if [ "${#names[@]}" -eq 0 ]; then
    mapfile -t names < <(cut -f1 "$d/inputs/benchmarks.txt")
fi
printf '%-28s %8s %10s %18s %10s %18s %7s %s\n' benchmark runs head head-range again again-range verdict "(user cycles; wall)"
for name in "${names[@]}"; do
    candidate=${CANDIDATE:-head}
    if [ "$candidate" = head ]; then
        mapfile -t files < <(ls "$d"/results/bench/"$name".2*.txt 2> /dev/null | grep -E "/$name\.[0-9T]+\.txt$")
    else
        mapfile -t files < <(ls "$d"/results/bench/"$name".2*."$candidate".txt 2> /dev/null)
    fi
    [ "${#files[@]}" -gt 0 ] || { printf '%-28s not measured\n' "$name"; continue; }
    for metric in cycles wall; do
        for f in "${files[@]}"; do
            placements=$(sed -n 's/.*placements \(.*\), runs .*/\1/p' "$f" | tail -1)
            awk -v placements="$placements" -v metric="$metric" '
                BEGIN { n = split(placements, shift, " ") }
                /^run [0-9]+ list 1 / {
                    build = $5; p = $7; sub(":", "", p)
                    value = ""
                    for (i = 1; i <= NF; i++) {
                        if (metric == "cycles" && $(i) == "user" && $(i + 1) == "cycles,") value = $(i - 1)
                        if (metric == "wall" && $(i) == "wall,") value = $(i - 2)
                    }
                    if (value != "") print build, shift[p], value
                }' "$f"
        done | sed "s/^$candidate /head /" | awk -v name="$name" -v metric="$metric" '
            function median(list, count,    sorted, i, j, t) {
                for (i = 1; i <= count; i++) sorted[i] = list[i]
                for (i = 2; i <= count; i++) { t = sorted[i]; j = i - 1; while (j >= 1 && sorted[j] > t) { sorted[j + 1] = sorted[j]; j-- } sorted[j + 1] = t }
                return count % 2 ? sorted[(count + 1) / 2] : (sorted[count / 2] + sorted[count / 2 + 1]) / 2
            }
            {
                all[$1, ++count[$1]] = $3
                key = $1 SUBSEP $2
                if (!(key in pcount)) { order[$1, ++places[$1]] = $2 }
                per[$1, $2, ++pcount[key]] = $3
            }
            END {
                for (b in count) { delete l; for (i = 1; i <= count[b]; i++) l[i] = all[b, i]; med[b] = median(l, count[b]) }
                for (b in places) for (k = 1; k <= places[b]; k++) {
                    s = order[b, k]; delete l
                    for (i = 1; i <= pcount[b SUBSEP s]; i++) l[i] = per[b, s, i]
                    pm[b, k] = median(l, pcount[b SUBSEP s])
                }
                split("head base-again", others, " ")
                line = sprintf("%-28s %8d", name " " metric, count["head"])
                for (o = 1; o <= 2; o++) {
                    b = others[o]
                    diff = 100 * (med[b] / med["base"] - 1)
                    lo = 1e9; hi = -1e9
                    for (k = 1; k <= places[b]; k++) for (q = 1; q <= places["base"]; q++) {
                        r = 100 * (pm[b, k] / pm["base", q] - 1); if (r < lo) lo = r; if (r > hi) hi = r
                    }
                    d[o] = diff; L[o] = lo; H[o] = hi
                    line = line sprintf(" %+9.2f%% %+7.2f%%..%+7.2f%%", diff, lo, hi)
                }
                floor = -L[2] > H[2] ? -L[2] : H[2]
                inside = (L[1] <= 0 && H[1] >= 0 && (d[1] < 0 ? -d[1] : d[1]) <= floor) ? "inside" : "OUTSIDE"
                print line, inside
            }'
    done
done
