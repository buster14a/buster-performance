#!/usr/bin/awk -f
# log9.txt's lane costs: a row per process (round, run, unit, lanes; then the one-lane reading's copy, dispatch and
# wake-up, and the reading on `lanes`'s), and with -v summary=1 the medians over the rounds of each run, unit and lane
# count, with the lowest and the highest. balanced's lines have no dispatch (its wake= is the first lane's whole time
# in lane_parts_by_cost): "-" there. Figures in microseconds.
function field(line, name,    at, rest)
{
    at = index(line, " " name "=")
    if (at == 0)
    {
        return "-"
    }
    rest = substr(line, at + length(name) + 2)
    sub(/[^0-9].*/, "", rest)
    return rest
}
function us(value)
{
    return value == "-" ? "-" : sprintf("%.1f", value / 1000)
}
function sort(values, count,    i, j, t)
{
    for (i = 2; i <= count; i += 1)
    {
        for (j = i; j > 1 && values[j - 1] + 0 > values[j] + 0; j -= 1)
        {
            t = values[j]
            values[j] = values[j - 1]
            values[j - 1] = t
        }
    }
}
BEGIN {
    if (!summary)
    {
        printf "round\trun\tunit\tlanes\tcopy1\tdispatch1\twake1\tcopy\tdispatch\twake\n"
    }
}
/^== round / {
    round = $3
    run = $4
    unit = $5
    lanes = $7
    seen = 0
    next
}
/^checker-deferred:   lanes=/ {
    seen += 1
    reading = seen == 1 ? "one" : "many"
    copy[reading] = field($0, "copy")
    dispatch[reading] = field($0, "dispatch")
    wake[reading] = field($0, "wake")
    if (seen == 2)
    {
        key = run "\t" unit "\t" lanes
        if (!(key in rounds))
        {
            order[++keys] = key
        }
        rounds[key] += 1
        n = rounds[key]
        values[key, "copy1", n] = copy["one"]
        values[key, "dispatch1", n] = dispatch["one"]
        values[key, "wake1", n] = wake["one"]
        values[key, "copy", n] = copy["many"]
        values[key, "dispatch", n] = dispatch["many"]
        values[key, "wake", n] = wake["many"]
        if (!summary)
        {
            printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", round, run, unit, lanes, us(copy["one"]), us(dispatch["one"]), us(wake["one"]),
                   us(copy["many"]), us(dispatch["many"]), us(wake["many"])
        }
    }
}
END {
    if (summary)
    {
        printf "run\tunit\tlanes\trounds\tcopy1\tdispatch1\twake1\tcopy\tdispatch\twake\n"
        split("copy1 dispatch1 wake1 copy dispatch wake", names, " ")
        for (k = 1; k <= keys; k += 1)
        {
            key = order[k]
            n = rounds[key]
            line = key "\t" n
            for (f = 1; f <= 6; f += 1)
            {
                delete list
                for (i = 1; i <= n; i += 1)
                {
                    list[i] = values[key, names[f], i]
                }
                if (list[1] == "-")
                {
                    line = line "\t-"
                }
                else
                {
                    sort(list, n)
                    line = line "\t" us(list[int((n + 1) / 2)]) " (" us(list[1]) " to " us(list[n]) ")"
                }
            }
            print line
        }
    }
}
