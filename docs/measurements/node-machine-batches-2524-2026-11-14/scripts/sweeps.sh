#!/bin/bash
# sweeps.sh FILE...: each time file's cycles per taken node for T, C (T+C less T), X (all less T+C) and all three.
for f in "$@"; do
  awk -v f="$f" '/node-shadow: time sweeps=/ { split($0, a, "per-evaluated-node: cycles="); split(a[2], b, " "); c[++n]=b[1] }
    END { if (n == 3) printf "%-60s T %6.1f  C %6.1f  X %6.1f  all %6.1f\n", f, c[1], c[2]-c[1], c[3]-c[2], c[3]; else printf "%-60s missing\n", f }' "$f"
done
