#!/bin/bash
# After roots-prof.sh's hold: each variant's eight profiles as one report by symbol, and the named symbols' hottest
# instructions. Usage: roots-prof-reduce.sh NAME SYMBOL... (the variants are found from the files)
set -u
name=$1; shift
cd ~/buster-fast-bench/1340-roots/results/"$name" || exit 1
test -f held || exit 1
for v in $(ls perf-*-1.data | sed 's/^perf-//; s/-1\.data$//'); do
    args=(); for f in perf-$v-*.data; do args+=(-i "$f"); done
    for f in perf-$v-*.data; do perf report -i "$f" --stdio --no-children --sort symbol -F period,symbol 2>/dev/null | grep -v '^#' | grep -v '^$'; done |
        awk '{ p[$3] += $1 } END { for (s in p) printf "%.3f %s\n", p[s] / 8e6, s }' | sort -rn > "by-symbol-$v.txt"
    for s in "$@"; do
        perf annotate -i "perf-$v-1.data" --stdio -s "$s" 2>/dev/null | awk '$1 + 0 >= 0.4' | sort -rn | head -60 > "annotate-$v-$s.txt"
    done
done
echo done > reduced
