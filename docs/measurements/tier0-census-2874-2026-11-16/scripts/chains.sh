#!/bin/bash
# chains.sh LABEL: every address of results/LABEL/*.ips with its inline chain, by llvm-symbolizer over the compiler's
# debug information (no lock: CPU 7, niceness 19). results/LABEL/chains.txt.
cd "$(dirname "$0")"
label=$1
out=results/$label
cat "$out"/*.ips | awk '{print "0x" $1}' | sort -u > scratch/addresses-$label.txt
taskset -c 7 nice -n 19 llvm-symbolizer -a -p -i -s --no-demangle --obj="$out/compiler" < scratch/addresses-$label.txt > "$out/chains.txt"
wc -l < scratch/addresses-$label.txt
grep -c '^0x' "$out/chains.txt"
