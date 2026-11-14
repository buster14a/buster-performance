#!/bin/bash
# leafcost.sh: for #892's item 6, main's cycles samples (the LBR run's cycles:u samples, period 200003, 8 compiles) by
# symbol, and check_graph_run's by its innermost inlined function and line, from llvm-symbolizer.
set -u
base=~/buster-fast-bench/892-claude
out=$base/results/leafcost
mkdir -p "$out"
perf script -i "$base/scratch/main-lbr.data" -F ip,sym,symoff 2> /dev/null | awk "{print \$2}" > "$out/samples.txt"
wc -l < "$out/samples.txt" > "$out/total.txt"
sed 's/+0x[0-9a-f]*$//' "$out/samples.txt" | sort | uniq -c | sort -rn | head -60 > "$out/symbols.txt"
grep '^check_graph_run' "$out/samples.txt" | sort | uniq -c | sort -rn > "$out/run-sites.txt"
awk '{print $2}' "$out/run-sites.txt" | llvm-symbolizer --obj="$base/bin/compiler-main" --inlining --functions=short --output-style=LLVM > "$out/run-sites.sym"
echo done > "$out/done"
