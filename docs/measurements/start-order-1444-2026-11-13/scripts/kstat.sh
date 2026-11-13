#!/bin/sh
# #1444's open items: perf stat (task clock, faults, user and kernel cycles, iTLB misses) of each BUILD's placement 0
# and base again (the floor, base-again), in 4 rounds of rotated order, warm (perf stat -r: each process right after
# the last of the same build), pinned to CPU 2; each round one hold of the 9700X's lock.
#   kstat.sh TAG BUILD...   (the first BUILD is the base)
set -e
d=~/buster-fast-bench/1444-claude-rest
. $d/env.sh
tag=$1
shift
builds="$* $1-again"
out=$d/results/kstat-$tag
mkdir -p $out
cd $d/inputs
for round in 1 2 3 4; do
    order=$(echo $builds | awk -v r=$round '{ n = NF; s = ""; for (i = 0; i < n; i++) { j = (i + r - 1) % n + 1; s = s " " $j } print s }')
    [ $round = 4 ] && order=$(echo $order | awk '{ s = ""; for (i = NF; i >= 1; i--) s = s " " $i; print s }')
    ~/buster-fast-bench/exclusive.sh sh -c "
        head -1 /var/lib/buster-9700x/owner >> $out/holds.txt
        for b in $order; do
            n=\${b%-again}
            C=$d/shifts-\$n/compiler-0
            e='-x, -e task-clock,page-faults,cycles:u,cycles:k,iTLB-load-misses'
            taskset -c 2 perf stat -r 300 \$e -o $out/\$b-syntax-$round.csv \$C -fsyntax-only empty.c > /dev/null 2>&1; echo \"\$b $round \$? \" >> $out/statuses.txt
            taskset -c 2 perf stat -r 300 \$e -o $out/\$b-preprocess-$round.csv \$C -E -P empty.c -o /dev/null > /dev/null 2>&1; echo \"\$b $round \$? \" >> $out/statuses.txt
            taskset -c 2 perf stat -r 300 \$e -o $out/\$b-tiny-$round.csv \$C -c tiny.c -o /dev/null > /dev/null 2>&1; echo \"\$b $round \$? \" >> $out/statuses.txt
            taskset -c 2 perf stat -r 300 \$e -o $out/\$b-tinyfirst-$round.csv \$C tiny.c -c -o /dev/null > /dev/null 2>&1; echo \"\$b $round \$? \" >> $out/statuses.txt
            taskset -c 2 perf stat -r 150 \$e -o $out/\$b-hello-$round.csv \$C -c hello.c -o /dev/null > /dev/null 2>&1; echo \"\$b $round \$? \" >> $out/statuses.txt
        done"
done
echo done > $out/done
