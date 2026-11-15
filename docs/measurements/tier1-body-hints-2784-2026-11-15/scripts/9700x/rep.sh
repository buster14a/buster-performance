#!/usr/bin/env bash
# Per-function cycle samples summed over the five runs of each revision and shift.
cd $HOME/buster-fast-bench/2784-claude/prof || exit 1
for n in 0 3696; do
    for t in base head; do
        for k in 1 2 3 4 5; do
            perf report -q -i $t-$n-$k.data --stdio --sort symbol -F overhead,sample,symbol 2>/dev/null | awk -v t=$t -v n=$n '{s=$2; $1=""; $2=""; sub(/^ +/, ""); print n, t, s, $0}'
        done
    done
done | awk '{key=$1" "$2" "$5; c[key]+=$3; tot[$1" "$2]+=$3} END {for (k in c) print k, c[k]; for (k in tot) print "TOTAL", k, tot[k]}' > sums.txt
for n in 0 3696; do
    echo "== shift $n"
    grep "^TOTAL $n " sums.txt
    awk -v n=$n '$1==n {v[$3][$2]=$4} END {for (f in v) printf "%s %d %d %+d\n", f, v[f]["base"], v[f]["head"], v[f]["head"]-v[f]["base"]}' sums.txt | sort -k4 -n | (head -8; echo ...; tail -12)
done
