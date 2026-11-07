#!/bin/bash
# 786-claude: one TSV row per (tree, shift, round, benchmark row): ns per instruction (benchmark-ir) or per input
# instruction (benchmark-ir-optimize).
cd ~/buster-fast-bench/786-claude/"$1"
for file in *-ir.txt; do
    IFS=- read -r tree bytes round _ <<< "${file%.txt}"
    awk -v t="$tree" -v s="$bytes" -v r="$round" '/^function:/ { n = $2 } $1 ~ /^(scalar|vector|uses|cfg)$/ && NF == 6 { printf "%s\t%s\t%s\tir-%s-%s\t%s\n", t, s, r, n, $1, $3 }' "$file"
done
for file in *-optimize.txt; do
    IFS=- read -r tree bytes round _ <<< "${file%.txt}"
    awk -v t="$tree" -v s="$bytes" -v r="$round" '/^ir-optimize / { shape = $2 } /^  (scalar|vector|auto) ns\/function/ { split($4, x, "="); printf "%s\t%s\t%s\topt-%s-%s\t%s\n", t, s, r, shape, $1, x[2] }' "$file"
done
