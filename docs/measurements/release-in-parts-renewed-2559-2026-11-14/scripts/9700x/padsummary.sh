#!/bin/bash
# padsummary.sh [NAME...]: for each benchmark's latest padbench.sh report, each build's median user cycles and
# instructions over its runs, against the first build's.
set -u
export LC_ALL=C
d=$HOME/buster-fast-bench/2559-step5b-claude
for name in "$@"; do
    f=$(ls "$d"/results/pad/"$name".2*.txt 2> /dev/null | tail -1)
    [ -n "$f" ] || { echo "$name not measured"; continue; }
    echo "== $name ($(tail -1 "$f"))"
    grep -E '^run [0-9]+ list 1 ' "$f" | awk '
        function median(list, count,    sorted, i, j, t) {
            for (i = 1; i <= count; i++) sorted[i] = list[i]
            for (i = 2; i <= count; i++) { t = sorted[i]; j = i - 1; while (j >= 1 && sorted[j] > t) { sorted[j + 1] = sorted[j]; j-- } sorted[j + 1] = t }
            return count % 2 ? sorted[(count + 1) / 2] : (sorted[count / 2] + sorted[count / 2 + 1]) / 2
        }
        {
            b = $5; sub(":", "", b)
            if (!(b in n)) order[++builds] = b
            for (i = 1; i <= NF; i++) {
                if ($(i) == "user" && $(i + 1) == "cycles,") c = $(i - 1)
                if ($(i) == "instructions" || $(i) == "instructions,") ins = $(i - 1)
                if ($(i) == "wall,") w = $(i - 2)
            }
            k = ++n[b]; cyc[b, k] = c; ii[b, k] = ins; wall[b, k] = w
        }
        END {
            for (o = 1; o <= builds; o++) {
                b = order[o]; delete l; delete m; delete q
                for (k = 1; k <= n[b]; k++) { l[k] = cyc[b, k]; m[k] = ii[b, k]; q[k] = wall[b, k] }
                mc[b] = median(l, n[b]); mi[b] = median(m, n[b]); mw[b] = median(q, n[b])
            }
            first = order[1]
            for (o = 1; o <= builds; o++) {
                b = order[o]
                printf "%-10s %4d runs %15.0f cyc %+7.2f%%  %15.0f ins %+7.2f%%  wall %+7.2f%%\n", b, n[b], mc[b], mc[first] ? 100 * (mc[b] / mc[first] - 1) : 0, mi[b], mi[first] ? 100 * (mi[b] / mi[first] - 1) : 0, 100 * (mw[b] / mw[first] - 1)
            }
        }'
done
