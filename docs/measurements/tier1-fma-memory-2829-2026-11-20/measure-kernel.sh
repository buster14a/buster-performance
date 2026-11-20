#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
label=$1
build=$2
kernel=$3
reps=$4
mkdir -p results
date -u -Iseconds > "results/$label.load"
cat /proc/loadavg >> "results/$label.load"
LC_ALL=C taskset -c 2 perf stat --no-big-num -x ';' -e cycles:u,instructions:u,branches:u,branch-misses:u,task-clock -o "results/$label.stat.new" -- "./programs/$build" "$kernel" "$reps" > "results/$label.stdout"
actual=$(awk '{print $NF}' "results/$label.stdout")
expected=$(awk -v k="$kernel" '$1==k {print $2}' expected.tsv)
[[ $actual == "$expected" ]]
date -u -Iseconds >> "results/$label.load"
cat /proc/loadavg >> "results/$label.load"
mv "results/$label.stat.new" "results/$label.stat"
