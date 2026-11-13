#!/bin/bash
# leafcost2.sh: leafcost.sh's check_graph_run samples symbolized by address, with their inline chains.
set -u
base=~/buster-fast-bench/892-claude
out=$base/results/leafcost
bin=$base/bin/compiler-main
start=$(nm "$bin" | awk '$3 == "check_graph_run.buster_split" {print $1; exit}')
echo "check_graph_run.buster_split at 0x$start" > "$out/start.txt"
awk -v s="$start" '{ split($2, p, "+"); printf "%s 0x%x\n", $1, strtonum("0x" s) + strtonum(p[2]) }' "$out/run-sites.txt" > "$out/run-addresses.txt"
awk '{print $2}' "$out/run-addresses.txt" | llvm-symbolizer --obj="$bin" --inlining --functions=short --output-style=LLVM > "$out/run-addresses.sym"
echo done > "$out/done2"
