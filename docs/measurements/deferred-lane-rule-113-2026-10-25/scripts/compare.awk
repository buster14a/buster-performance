# Before and after, from rows.awk's rows (GNU awk): for each unit, each tree's eight-lane reading against its one-lane
# reading in the same process, as the lowest, the highest and the median change over the rounds; the lanes the rule ran;
# and the medians of the two trees' eight-lane readings (ns/token) with the change between. -v after=TREE and
# -v before=TREE name the trees (rule and probe by default; balanced and balanced-every for queue7 and queue8), and
# -v also=TREE a third whose changes are shown too.
#
#   awk -v after=balanced -v before=balanced-every -f compare.awk rows.tsv
function median(values,    sorted, n)
{
    n = asort(values, sorted)
    return n == 0 ? 0 : n % 2 == 1 ? sorted[(n + 1) / 2] : (sorted[n / 2] + sorted[n / 2 + 1]) / 2
}
function range(tree, unit,    i, a, low, high)
{
    if (count[tree, unit] == 0) return "-"
    low = 1e9; high = -1e9
    for (i = 1; i <= count[tree, unit]; i += 1)
    {
        a[i] = change[tree, unit, i]
        low = a[i] < low ? a[i] : low
        high = a[i] > high ? a[i] : high
    }
    return sprintf("%+.1f to %+.1f (%+.1f)", low, high, median(a))
}
function eight(tree, unit,    i, a)
{
    for (i = 1; i <= count[tree, unit]; i += 1)
    {
        a[i] = many[tree, unit, i]
    }
    return median(a)
}
BEGIN {
    FS = OFS = "\t"
    after = after == "" ? "rule" : after
    before = before == "" ? "probe" : before
}
NR == 1 { next }
{
    tree = $2; unit = $3
    if (!(unit in seen)) { seen[unit] = 1; order[++units] = unit }
    n = ++count[tree, unit]
    change[tree, unit, n] = ($11 / $10 - 1) * 100
    many[tree, unit, n] = $11
    if (tree == after) { active[unit] = $12; tokens[unit] = $7; largest[unit] = $8; rounds[unit] = n }
}
END {
    print "unit", "body_tokens", "largest", "lanes", "rounds", before "_8_vs_1", after "_8_vs_1", also != "" ? also "_8_vs_1" : "-", before "_8", after "_8",
          after "_8_vs_" before "_8"
    for (i = 1; i <= units; i += 1)
    {
        unit = order[i]
        b = eight(before, unit); a = eight(after, unit)
        print unit, tokens[unit], largest[unit], active[unit], rounds[unit], range(before, unit), range(after, unit), also != "" ? range(also, unit) : "-",
              sprintf("%.2f", b), sprintf("%.2f", a), b != 0 ? sprintf("%+.1f%%", (a / b - 1) * 100) : "-"
    }
}
