#!/bin/bash
# lines.sh LABEL N: per-source-line samples of prof/LABEL-*.data in the common warnings' files, summed, as M cycles per compile.
cd ~/buster-fast-bench/1360-claude
for f in prof/$1-*.data; do perf report -q --no-children --sort srcline -F sample,srcline -i $f 2>/dev/null; done | awk -v n=$2 -v p=200010 '{s=$1; $1=""; sub(/^ +/,""); a[$0]+=s} END{for(k in a) printf "%8.2f\t%s\n", a[k]*p/n/1e6, k}' | sort -g -r > prof/$1-lines.txt
