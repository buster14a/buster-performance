#!/bin/bash
# ticks.sh LABEL SUFFIX COUNT CORPUS...: per corpus, the typed records and the medians of ticks and setup ticks of the
# sweeps' and the tests' readings, and the tests' own ticks a record (the difference).
cd ~/buster-fast-bench/2524-claude-1b/results/$1
suffix=$2; count=$3; shift 3
for c in "$@"; do
    for t in sweeps tests; do
        for n in $(seq 1 $count); do f=types-$t-$c$suffix-$n.txt; test -f $f && grep "reader-time T expressions" $f | sed "s/.*typed=\([0-9]*\).*ticks=\([0-9]*\) setup-ticks=\([0-9]*\)/\1 \2 \3/"; done | sort -k2 -n | awk -v t=$t -v c=$c '{ r[NR] = $1; k[NR] = $2; s[NR] = $3 } END { m = int((NR + 1) / 2); printf "%s %s readings=%d typed=%d ticks=%d (%.1f a record) setup=%d\n", c, t, NR, r[m], k[m], k[m] / r[m], s[m] }'
    done
done
