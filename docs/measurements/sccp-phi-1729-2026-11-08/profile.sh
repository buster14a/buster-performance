#!/bin/bash
# One lock hold: perf's cycles:u profile of each binary's -c --tier1 of INPUT, the top symbols.
set -u
D=$HOME/buster-fast-bench/1729-opencode
A=${A:-base}; B=${B:-head}
input=$1
for b in $A $B; do
    echo "== $b $input"
    taskset -c 2 perf record -q -e cycles:u -c 200003 -o "$D/out/$b.$(basename $input).perf" "$D/bin/$b" -c --tier1 "$D/$input" -o "$D/out/perf.$b.o" > /dev/null 2>&1
    perf report -i "$D/out/$b.$(basename $input).perf" --no-children --percent-limit 0.5 --stdio 2>/dev/null | grep -v '^#' | grep -v '^$' | head -12
done
