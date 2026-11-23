#!/bin/bash
# Reduce the profile's samples by symbol.
set -euo pipefail
out=~/buster-fast-bench/2536-claude-kcl1ed/results/${1:?out}
for w in one eight; do
    perf script -i "$out/$w.data" -F event,ip,sym 2> "$out/$w.script.err" | awk '{ e=$1; sub(/:$/, "", e); s=$3; for (i = 4; i <= NF; i++) s = s " " $i; if (s == "") s = "[" $2 "]"; c[e "\t" s] += 1 } END { for (k in c) print c[k] "\t" k }' | sort -rn > "$out/$w.sym.tsv"
done
perf script -i "$out/one.data" -F event,ip,sym 2>/dev/null | head -5
wc -l "$out"/*.sym.tsv
echo REDUCE-DONE
