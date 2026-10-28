# rows.awk's rows by run, unit and lane count over the rounds (GNU awk): each process's change of its lanes' reading
# against its one lane's, as the lowest, the median and the highest; the medians of the one lane's and the lanes'
# readings and of the lanes' span (ns/token); the lanes that ran and copied; a copy on the lanes (ns), the wake-up (ns);
# and the passes in which the first lane read the largest body, summed over the rounds, of all the passes.
#
#   awk -f summary.awk rows.tsv
function median(values,    sorted, n)
{
    n = asort(values, sorted)
    return n == 0 ? 0 : n % 2 == 1 ? sorted[(n + 1) / 2] : (sorted[n / 2] + sorted[n / 2 + 1]) / 2
}
BEGIN {
    FS = OFS = "\t"
}
NR == 1 { next }
{
    key = $2 SUBSEP $3 SUBSEP $4
    if (!(key in count)) { order[++keys] = key; tokens[key] = $5; bodies[key] = $6; body_tokens[key] = $7; largest[key] = $8; second[key] = $9 }
    n = ++count[key]
    change[key, n] = ($12 / $11 - 1) * 100
    one[key, n] = $11
    many[key, n] = $12
    span[key, n] = $23
    active[key] = $13
    copies[key] = $15
    copyL[key, n] = $17
    wake[key, n] = $19
    if ($25 != "-") { split($25, f, "/"); first[key] += f[1]; passes[key] += f[2] }
}
END {
    print "run", "unit", "lanes", "tokens", "bodies", "body_tokens", "largest", "second", "rounds", "change_low%", "change_median%", "change_high%", "one_lane",
          "lanes", "span", "active", "copies", "copy_lanes_ns", "wake_ns", "largest_first"
    for (k = 1; k <= keys; k += 1)
    {
        key = order[k]
        split(key, parts, SUBSEP)
        n = count[key]
        delete a; delete b; delete c; delete e; delete g; delete h
        low = 1e9; high = -1e9
        for (i = 1; i <= n; i += 1)
        {
            a[i] = change[key, i]; b[i] = one[key, i]; c[i] = many[key, i]; e[i] = copyL[key, i]; g[i] = wake[key, i]; h[i] = span[key, i]
            low = a[i] < low ? a[i] : low
            high = a[i] > high ? a[i] : high
        }
        printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%d\t%+.1f\t%+.1f\t%+.1f\t%.2f\t%.2f\t%.2f\t%s\t%s\t%.0f\t%.0f\t%s\n", parts[1], parts[2], parts[3], tokens[key],
               bodies[key], body_tokens[key], largest[key], second[key], n, low, median(a), high, median(b), median(c), median(h), active[key], copies[key],
               median(e), median(g), (key in passes) ? first[key] "/" passes[key] : "-"
    }
}
