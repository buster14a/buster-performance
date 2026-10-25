# rows.awk's rows by tree, unit and lane count over the rounds (GNU awk): each process's change of its lanes' reading
# against its one lane's, as the lowest, the median and the highest; and the medians of the one lane's and the lanes'
# readings (ns/token), the lanes that ran and copied, a copy on one lane and on the lanes (ns), the wake-up (ns), and a
# body token's walk on one lane and over the lanes (ns per body token).
#
#   awk -f summary.awk rows.tsv
function median(values, count,    sorted, n)
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
    if (!(key in count)) { order[++keys] = key; tokens[key] = $5; bodies[key] = $6; body_tokens[key] = $7; largest[key] = $8 }
    n = ++count[key]
    change[key, n] = ($11 / $10 - 1) * 100
    one[key, n] = $10
    many[key, n] = $11
    active[key] = $12
    copies[key] = $14
    copy1[key, n] = $15
    copyL[key, n] = $16
    wake[key, n] = $18
    # Walks are ns/token over the unit's tokens: per body token, scale by tokens / body_tokens.
    walk1[key, n] = $7 != 0 ? $19 * $5 / $7 : 0
    walkL[key, n] = $7 != 0 ? $20 * $5 / $7 : 0
}
END {
    print "tree", "unit", "lanes", "tokens", "bodies", "body_tokens", "largest", "rounds", "change_low%", "change_median%", "change_high%", "one_lane", "lanes",
          "active", "copies", "copy_one_ns", "copy_lanes_ns", "wake_ns", "walk_one_ns_per_body_token", "walk_lanes_ns_per_body_token"
    for (k = 1; k <= keys; k += 1)
    {
        key = order[k]
        split(key, parts, SUBSEP)
        n = count[key]
        delete a; delete b; delete c; delete d; delete e; delete f; delete g; delete h
        low = 1e9; high = -1e9
        for (i = 1; i <= n; i += 1)
        {
            a[i] = change[key, i]; b[i] = one[key, i]; c[i] = many[key, i]; d[i] = copy1[key, i]; e[i] = copyL[key, i]; f[i] = wake[key, i]
            g[i] = walk1[key, i]; h[i] = walkL[key, i]
            low = a[i] < low ? a[i] : low
            high = a[i] > high ? a[i] : high
        }
        printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%d\t%+.1f\t%+.1f\t%+.1f\t%.2f\t%.2f\t%s\t%s\t%.0f\t%.0f\t%.0f\t%.2f\t%.2f\n", parts[1], parts[2], parts[3],
               tokens[key], bodies[key], body_tokens[key], largest[key], n, low, median(a), high, median(b), median(c), active[key], copies[key], median(d), median(e),
               median(f), median(g), median(h)
    }
}
