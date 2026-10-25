# One row per benchmark-checker-deferred process of a queue's log: its round, tree (when the heading names one), unit
# and lane count, the unit's tokens, bodies, bodies' tokens and the largest body's (when printed), and for one lane and
# for the process's lanes: the whole
# reading (ns/token), the lanes that ran (active, when printed) and copied the reader, a copy (ns/lane), the wake-up
# (ns), the bodies' walks summed over the lanes (ns/token) and the lanes' span (ns/token).
#
#   awk -f rows.awk log.txt > rows.tsv
#
# Headings are "== round R UNIT lanes L" or "== round R TREE UNIT lanes L".
function field(line, name,    i, n, parts, kv)
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
BEGIN {
    OFS = "\t"
    print "round", "tree", "unit", "lanes", "tokens", "bodies", "body_tokens", "largest", "source_order", "whole1", "wholeL", "activeL", "copies1", "copiesL",
          "copy1", "copyL", "wake1", "wakeL", "walks1", "walksL", "span1", "spanL"
}
/^== round / {
    round = $3
    if ($5 == "lanes") { tree = "-"; unit = $4; lanes = $6 } else { tree = $4; unit = $5; lanes = $7 }
    seen = 0
    next
}
/^checker-deferred: file=/ {
    tokens = field($0, "tokens"); bodies = field($0, "bodies"); body_tokens = field($0, "body_tokens"); source_order = field($0, "source_order")
    largest = field($0, "largest_body"); largest = largest == "" ? "-" : largest
    next
}
/^checker-deferred:   lanes=/ {
    seen += 1
    if (seen == 1)
    {
        whole1 = field($0, "whole"); copies1 = field($0, "copies"); copy1 = field($0, "copy"); wake1 = field($0, "wake")
        walks1 = field($0, "walks"); span1 = field($0, "lanes_span")
    }
    else
    {
        active = field($0, "active")
        print round, tree, unit, lanes, tokens, bodies, body_tokens, largest, source_order, whole1, field($0, "whole"), active == "" ? "-" : active, copies1,
              field($0, "copies"), copy1, field($0, "copy"), wake1, field($0, "wake"), walks1, field($0, "walks"), span1, field($0, "lanes_span")
    }
}
