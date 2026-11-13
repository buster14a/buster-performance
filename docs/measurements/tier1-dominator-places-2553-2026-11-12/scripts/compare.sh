#!/bin/bash
# compare.sh DIR...: per measurement, speedtest1's and Lua's (five scripts summed) program instructions, edge moves
# (e+h+x), edge stores (T+t), edge reloads (U+u) and the rest of the tags, from each DIR/summary.txt.
for d in "$@"; do
    awk -v d=$(basename $d) '
    /^(st|calls|tables|strings|arithmetic|closures) total/ {
        p = ($1 == "st") ? "st" : "lua"
        tot[p] += $3
        for (i = 4; i <= NF; i++) { if ($i == "|") break; split($i, kv, "="); v[p, kv[1]] += kv[2] }
    }
    END {
        for (pi = 1; pi <= 2; pi++) {
            p = pi == 1 ? "st" : "lua"
            m = v[p,"e"] + v[p,"h"] + v[p,"x"]; s = v[p,"T"] + v[p,"t"]; r = v[p,"U"] + v[p,"u"]
            printf "%-8s %-4s total %8.1f M  moves %6.1f (e %5.1f h %5.1f x %5.1f)  stores %5.1f (T %5.1f t %5.1f)  reloads %5.1f (U %5.1f u %5.1f)  all %6.1f\n", d, p, tot[p]/1e6, m/1e6, v[p,"e"]/1e6, v[p,"h"]/1e6, v[p,"x"]/1e6, s/1e6, v[p,"T"]/1e6, v[p,"t"]/1e6, r/1e6, v[p,"U"]/1e6, v[p,"u"]/1e6, (m+s+r)/1e6
        }
    }' $d/summary.txt
done
