#!/bin/bash
# sweeps-i.sh FILE...: as sweeps.sh, instructions per taken node.
for f in "$@"; do
  awk -v f="$f" '/node-shadow: time sweeps=/ { split($0, a, "instructions="); split(a[3], b, " "); c[++n]=b[1] }
    END { if (n == 3) printf "%-40s T %6.1f  C %6.1f  X %6.1f  all %6.1f\n", f, c[1], c[2]-c[1], c[3]-c[2], c[3]; else printf "%-40s missing\n", f }' "$f"
done
