#!/bin/bash
# speedtest1's runs on CPU 2: one untimed warm-up run of each build, then ROUNDS rounds of the builds in a rotating
# order, each from a fresh database (run.times: round, build, wall microseconds, user and system seconds, speedtest1's
# own TOTAL; each run's output in runs/).
set -u
. "$(dirname "$0")/st-env.sh"
cd $M || exit 1
rounds=${1:-11}
builds=()
for c in ${BUILDS[@]}; do
    [ -x st-$c ] && builds+=($c)
done
n=${#builds[@]}
rm -rf runs && mkdir -p runs
for c in ${builds[@]}; do
    run $c $M/runs/warmup-$c.txt > /dev/null
done
: > run.times
for r in $(seq 0 $(( rounds - 1 ))); do
    for i in $(seq 0 $(( n - 1 ))); do
        c=${builds[$(( (r + i) % n ))]}
        o=$M/runs/r$r-$c.txt
        echo "$r $c $(run $c $o) $(awk '/TOTAL/ {print $2}' $o)" >> run.times
    done
done
median() { sort -n | awk '{v[NR]=$1} END {print v[int((NR+1)/2)]}'; }
for c in ${builds[@]}; do
    echo "$c: wall $(awk -v c=$c '$2 == c {print $3}' run.times | median) us, user $(awk -v c=$c '$2 == c {print $4}' run.times | median) s, system $(awk -v c=$c '$2 == c {print $5}' run.times | median) s, TOTAL $(awk -v c=$c '$2 == c {print $6}' run.times | tr -d s | median) s (medians of $rounds)"
done
