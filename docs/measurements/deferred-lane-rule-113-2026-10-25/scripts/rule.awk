# The rule against the grids (GNU awk): for each unit, its bodies' tokens beyond twice the largest body's, the lanes the
# rule gives it on 8 (one, and one more per N of those tokens, no more than the bodies), the median change of its
# reading on those lanes against one lane (a lane count the grid hasn't is the mean of its neighbours', "?" without
# them), and the best change the grid measured, with its lanes.
#
#   awk -v n=12288 -f rule.awk largest.tsv summary.tsv...
BEGIN { FS = OFS = "\t" }
FNR == NR { largest[$1] = $2; next }
FNR == 1 { next }
{
    unit = $2
    if (!(unit in seen)) { seen[unit] = 1; order[++units] = unit }
    bodies[unit] = $5; tokens[unit] = $6
    change[unit, $3] = $10
    if (!((unit) in best) || $10 + 0 < best[unit]) { best[unit] = $10 + 0; best_lanes[unit] = $3 }
}
function at(unit, lanes)
{
    if (lanes == 1) return "+0.0"
    if ((unit, lanes) in change) return change[unit, lanes]
    if ((unit, lanes - 1) in change && (unit, lanes + 1) in change) return sprintf("%+.1f", (change[unit, lanes - 1] + change[unit, lanes + 1]) / 2)
    return "?"
}
END {
    print "unit", "body_tokens", "largest", "beyond", "lanes", "change%", "best%", "best_lanes"
    for (i = 1; i <= units; i += 1)
    {
        unit = order[i]
        if (!(unit in largest)) continue
        beyond = tokens[unit] - 2 * largest[unit]
        beyond = beyond > 0 ? beyond : 0
        lanes = 1 + int(beyond / n)
        lanes = lanes > 8 ? 8 : lanes
        lanes = lanes > bodies[unit] ? bodies[unit] : lanes
        b = best[unit] < 0 ? sprintf("%+.1f", best[unit]) : "+0.0"
        print unit, tokens[unit], largest[unit], beyond, lanes, at(unit, lanes), b, best[unit] < 0 ? best_lanes[unit] : 1
    }
}
