#!/bin/bash
# summarize.sh [RUNS.TSV] [COMPILE-PERF.TSV]: runs.sh's measured rounds as the design's tables give them. Per program
# and placement, each tree's median of user cycles over the rounds; speedtest1's change as 100 ln(head / main) per
# placement, then their mean with its 95% interval over the eight placements (Student's t, 7 degrees of freedom; a
# placement's rounds are not independent draws of a layout) and the placements at which head's median is the lower;
# Lua's the same over its four link orders (3 degrees of freedom), each order's cycles the sum of its five scripts'
# medians, and each script alone. Then compile.sh's runs: each tree's median user cycles, instructions and task-clock.
set -u
runs=${1:-results/runs/runs.tsv}
compile=${2:-results/compile/perf.tsv}
awk -F'\t' '
$1 == "measured" { key = $3 SUBSEP $4 SUBSEP $5; n = ++count[key]; value[key, n] = $7 }
function median(key,    n, i, j, t, a) {
    n = count[key]
    for (i = 1; i <= n; i++) a[i] = value[key, i]
    for (i = 1; i <= n; i++) for (j = i + 1; j <= n; j++) if (a[j] < a[i]) { t = a[i]; a[i] = a[j]; a[j] = t }
    return n % 2 ? a[(n + 1) / 2] : (a[n / 2] + a[n / 2 + 1]) / 2
}
function report(name, places, np, tvalue, base, head,    i, s, ss, mean, sd, half, faster, d) {
    s = 0; ss = 0; faster = 0
    for (i = 1; i <= np; i++) { d[i] = 100 * log(head[i] / base[i]); s += d[i]; faster += head[i] < base[i] }
    mean = s / np
    for (i = 1; i <= np; i++) ss += (d[i] - mean) ^ 2
    sd = np > 1 ? sqrt(ss / (np - 1)) : 0
    half = tvalue * sd / sqrt(np)
    printf "%-12s %+7.2f (%+.2f to %+.2f)  faster at %d of %d  main %.1f M  head %.1f M  per placement:", name, mean, mean - half, mean + half, faster, np, avg(base, np) / 1e6, avg(head, np) / 1e6
    for (i = 1; i <= np; i++) printf " %+.2f", d[i]
    printf "\n"
}
function avg(a, n,    i, s) { s = 0; for (i = 1; i <= n; i++) s += a[i]; return s / n }
END {
    split("0 528 1056 1584 2112 2640 3168 3696", shifts, " ")
    for (i = 1; i <= 8; i++) { b[i] = median("speedtest1" SUBSEP shifts[i] SUBSEP "main"); h[i] = median("speedtest1" SUBSEP shifts[i] SUBSEP "head") }
    report("speedtest1", shifts, 8, 2.365, b, h)
    split("0 8 16 24", orders, " ")
    split("calls tables strings arithmetic closures", scripts, " ")
    for (i = 1; i <= 4; i++) { lb[i] = 0; lh[i] = 0 }
    for (k = 1; k <= 5; k++) {
        for (i = 1; i <= 4; i++) {
            sb[i] = median(scripts[k] SUBSEP orders[i] SUBSEP "main"); sh[i] = median(scripts[k] SUBSEP orders[i] SUBSEP "head")
            lb[i] += sb[i]; lh[i] += sh[i]
        }
        report("lua " scripts[k], orders, 4, 3.182, sb, sh)
    }
    report("lua (sum)", orders, 4, 3.182, lb, lh)
}' "$runs"
[ -f "$compile" ] && awk -F'\t' '
{ n = ++count[$2]; clock[$2, n] = $3; cycles[$2, n] = $4; instructions[$2, n] = $5 }
function median(array, tree,    n, i, j, t, a) {
    n = count[tree]
    for (i = 1; i <= n; i++) a[i] = array[tree, i]
    for (i = 1; i <= n; i++) for (j = i + 1; j <= n; j++) if (a[j] < a[i]) { t = a[i]; a[i] = a[j]; a[j] = t }
    return n % 2 ? a[(n + 1) / 2] : (a[n / 2] + a[n / 2 + 1]) / 2
}
END {
    for (tree in count) printf "compile %-5s runs %d  task-clock %.1f ms  user cycles %.1f M  instructions %.1f M\n", tree, count[tree], median(clock, tree), median(cycles, tree) / 1e6, median(instructions, tree) / 1e6
    if (("main" in count) && ("head" in count))
        printf "compile head/main  task-clock %+.2f%%  cycles %+.2f%%  instructions %+.2f%%\n", 100 * (median(clock, "head") / median(clock, "main") - 1),
               100 * (median(cycles, "head") / median(cycles, "main") - 1), 100 * (median(instructions, "head") / median(instructions, "main") - 1)
}' "$compile"
