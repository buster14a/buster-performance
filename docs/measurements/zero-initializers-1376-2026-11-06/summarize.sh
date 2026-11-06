#!/bin/bash
# Each executable's median over the rounds, per kernel or size: summarize.sh results/run-*/kernels.txt (or sizes.txt).
awk '$3 != "check" { v[$2 " " $3] = v[$2 " " $3] " " $4 }
     END { for (k in v) { n = split(substr(v[k], 2), x, " "); asort(x); printf "%s %.3f\n", k, x[int((n + 1) / 2)] } }' "$1" | sort
