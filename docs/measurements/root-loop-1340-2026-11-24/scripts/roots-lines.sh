#!/bin/bash
# After roots-prof.sh's hold of the -g compilers: each variant's cycles by source line, for the lines of the common
# warnings' files. Usage: roots-lines.sh NAME
set -u
cd ~/buster-fast-bench/1340-roots/results/"$1" || exit 1
test -f held || exit 1
for v in $(ls perf-*-1.data | sed 's/^perf-//; s/-1\.data$//'); do
    for f in perf-$v-*.data; do perf report -i "$f" --stdio --no-children --sort srcline -F period,srcline 2>/dev/null | grep -v '^#' | grep -v '^$'; done |
        awk '{ p[$2] += $1 } END { for (s in p) printf "%.4f %s\n", p[s] / 8e6, s }' | sort -rn > "by-line-$v.txt"
done
echo done > lines
