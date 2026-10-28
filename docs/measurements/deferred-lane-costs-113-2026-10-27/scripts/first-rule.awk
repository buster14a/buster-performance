# A lane rule against a grid (GNU awk): for each unit of summary.awk's rows of one run (-v run=NAME), its bodies' tokens
# beyond the rule's critical path, the lanes the rule gives it on 8 (one, and one more per N of those tokens, no more
# than the bodies), the median change of its reading on those lanes against one lane (a lane count the grid hasn't is
# the mean of its nearest measured neighbours', "?" without them), and the best change the grid measured, with its
# lanes. The critical path is the larger of `largest` times the largest body's tokens and `second` times the largest
# of the others' (2 and 0 by default, #448's rule).
#
#   awk -v run=variants-every-first -v n=12288 -v largest=1 -v second=2 -f rule.awk summary.tsv
BEGIN { FS = OFS = "\t"; largest = largest == "" ? 2 : largest; second = second == "" ? 0 : second }
FNR == 1 { next }
$1 == run {
    unit = $2
    if (!(unit in seen)) { seen[unit] = 1; order[++units] = unit }
    bodies[unit] = $5; tokens[unit] = $6; big[unit] = $7; next_big[unit] = $8
    change[unit, $3] = $11
    if (!(unit in best) || $11 + 0 < best[unit]) { best[unit] = $11 + 0; best_lanes[unit] = $3 }
}
function at(unit, lanes,    low, high)
{
    if (lanes == 1) return "+0.0"
    if ((unit, lanes) in change) return change[unit, lanes]
    for (low = lanes - 1; low > 1 && !((unit, low) in change); low -= 1) { }
    for (high = lanes + 1; high <= 8 && !((unit, high) in change); high += 1) { }
    if (low > 1 && high <= 8)
    {
        return sprintf("%+.1f", change[unit, low] + (change[unit, high] - change[unit, low]) * (lanes - low) / (high - low))
    }
    return "?"
}
END {
    print "unit", "body_tokens", "largest", "second", "path", "beyond", "lanes", "change%", "best%", "best_lanes"
    for (i = 1; i <= units; i += 1)
    {
        unit = order[i]
        path = largest * big[unit]
        path = second * next_big[unit] > path ? second * next_big[unit] : path
        beyond = tokens[unit] - path
        beyond = beyond > 0 ? beyond : 0
        lanes = 1 + int(beyond / n)
        lanes = lanes > 8 ? 8 : lanes
        lanes = lanes > bodies[unit] ? bodies[unit] : lanes
        b = best[unit] < 0 ? sprintf("%+.1f", best[unit]) : "+0.0"
        print unit, tokens[unit], big[unit], next_big[unit], path, beyond, lanes, at(unit, lanes), b, best[unit] < 0 ? best_lanes[unit] : 1
    }
}
