# One row per benchmark-checker-deferred process of a queue's log: its round, run (the tree, with -every for
# --every-lane and the take for --take), unit and lane count, the unit's tokens, bodies, bodies' tokens, the largest
# body's and the largest of the others' (when printed), source order's reading, and for one lane and for the process's
# lanes: the whole reading (ns/token), the lanes that ran and copied the reader, a copy (ns/lane), the wake-up (ns), the
# bodies' walks summed over the lanes (ns/token), the lanes' span (ns/token), and the passes in which the first lane
# read the largest body (when printed).
#
#   awk -f rows.awk log.txt > rows.tsv
#
# Headings are "== round R RUN UNIT lanes L".
function field(line, name,    i, n, parts)
{
    n = split(line, parts, /[ ,]+/)
    for (i = 1; i <= n; i += 1)
    {
        if (index(parts[i], name "=") == 1)
        {
            return substr(parts[i], length(name) + 2)
        }
    }
    return ""
}
function or_dash(value)
{
    return value == "" ? "-" : value
}
BEGIN {
    OFS = "\t"
    print "round", "run", "unit", "lanes", "tokens", "bodies", "body_tokens", "largest", "second", "source_order", "whole1", "wholeL", "activeL", "copies1",
          "copiesL", "copy1", "copyL", "wake1", "wakeL", "walks1", "walksL", "span1", "spanL", "first1", "firstL"
}
/^== round / {
    round = $3; run = $4; unit = $5; lanes = $7
    seen = 0
    next
}
/^checker-deferred: file=/ {
    tokens = field($0, "tokens"); bodies = field($0, "bodies"); body_tokens = field($0, "body_tokens"); source_order = field($0, "source_order")
    largest = or_dash(field($0, "largest_body")); second = or_dash(field($0, "second_body"))
    next
}
/^checker-deferred:   lanes=/ {
    seen += 1
    if (seen == 1)
    {
        whole1 = field($0, "whole"); copies1 = field($0, "copies"); copy1 = field($0, "copy"); wake1 = field($0, "wake")
        walks1 = field($0, "walks"); span1 = field($0, "lanes_span"); first1 = or_dash(field($0, "largest_first"))
    }
    else
    {
        print round, run, unit, lanes, tokens, bodies, body_tokens, largest, second, source_order, whole1, field($0, "whole"), or_dash(field($0, "active")),
              copies1, field($0, "copies"), copy1, field($0, "copy"), wake1, field($0, "wake"), walks1, field($0, "walks"), span1, field($0, "lanes_span"),
              first1, or_dash(field($0, "largest_first"))
    }
}
