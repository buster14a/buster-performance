#!/bin/bash
# #877: the record's summaries, from its raw results. Usage: analyze.sh RESULTS PAIR...  where each PAIR is BASE:HEAD,
# two trees' names as their executables' directories give them (bin/TREE/compiler-OFFSET). It prints:
# - each pair's stage medians (summarize.sh) from stages-*.txt;
# - each offset's medians of the stages that #877's changes reach, by tree;
# - for each of those stages, how many of the merge's offset medians are above how many of the base's (of 64 pairs:
#   the Mann-Whitney U count, about 51 or more, or 13 or fewer, for p < 0.05 two-sided at eight and eight);
# - time-runs' comparisons, round by round, from time-*.txt;
# - each build's instructions per process over every round's time-runs processes.
set -u
export LC_ALL=C
results=$1; shift
here=$(dirname "$0")
cat $results/stages-*.txt > /tmp/analyze-stages.$$
for pair in "$@"; do
    echo "== stages, ${pair%%:*} against ${pair#*:} (medians over offsets and rounds, ms)"
    bash $here/summarize.sh /tmp/analyze-stages.$$ ${pair%%:*} ${pair#*:}
    echo
done
awk -v pairs="$*" '
function med(a, n,   i, j, t) { for (i = 2; i <= n; i++) { t = a[i]; for (j = i - 1; j >= 1 && a[j] > t; j--) a[j + 1] = a[j]; a[j + 1] = t } return n % 2 ? a[(n + 1) / 2] : (a[n / 2] + a[n / 2 + 1]) / 2 }
/^== round / { n = split($5, p, "/"); tree = p[n - 1]; off = p[n]; sub(/compiler-/, "", off); if (!(off in so)) { so[off] = 1; offs[++oc] = off } next }
/^default: median of/ { v[tree, off, "wall", ++c[tree, off, "wall"]] = $5; next }
/^  (check-input|check-program|lower|span) / { v[tree, off, $1, ++c[tree, off, $1]] = $2 }
END {
    ns = split("wall check-input check-program lower span", st, " ")
    np = split(pairs, pr, " ")
    for (s = 1; s <= ns; s++) {
        printf "== %s: each offset'"'"'s median over its rounds (ms); offsets", st[s]
        for (o = 1; o <= oc; o++) printf " %8s", offs[o]
        printf "\n"
        for (q = 1; q <= np; q++) {
            split(pr[q], t2, ":")
            for (w = 1; w <= 2; w++) {
                tr = t2[w]
                if (done[tr, st[s]]) continue
                done[tr, st[s]] = 1
                printf "  %-10s", tr
                for (o = 1; o <= oc; o++) { k = 0; delete a; for (r = 1; r <= c[tr, offs[o], st[s]]; r++) a[++k] = v[tr, offs[o], st[s], r]; m[tr, st[s], o] = med(a, k); printf " %8.3f", m[tr, st[s], o] }
                printf "\n"
            }
        }
        for (q = 1; q <= np; q++) {
            split(pr[q], t2, ":"); above = 0; below = 0
            for (i = 1; i <= oc; i++) for (j = 1; j <= oc; j++) { above += m[t2[2], st[s], i] > m[t2[1], st[s], j]; below += m[t2[2], st[s], i] < m[t2[1], st[s], j] }
            printf "  %s against %s: the merge above in %d of %d offset pairs, below in %d\n", t2[2], t2[1], above, oc * oc, below
        }
    }
}' /tmp/analyze-stages.$$
rm -f /tmp/analyze-stages.$$
echo
echo "== time-runs' comparisons by round"
for f in $results/time-*.txt; do
    grep -v '^list 1 [a-z-]* placement [0-9]* copy [0-9]* \[\|^run [0-9]* list\|^exclusive\|^  title\|^  link\|^  pull request\|^memory' $f
done
echo
echo "== instructions per process, every round's time-runs processes"
cat $results/time-*.txt | awk '/^== round/ { pair = $4 == "pair" ? $5 ":" $6 : "all" } /^run [0-9]+ list 1 / { b = $5; for (i = 1; i <= NF; i++) if ($i == "instructions,") x = $(i - 1); key = pair " " b; n[key]++; s[key] += x; if (!(key in lo) || x < lo[key]) lo[key] = x; if (x > hi[key]) hi[key] = x }
    END { for (k in n) printf "  %-28s %4d processes, mean %.0f, from %d to %d\n", k, n[k], s[k] / n[k], lo[k], hi[k] }' | sort
