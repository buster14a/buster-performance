#!/bin/bash
# produce-run.sh COMPILER OUT: the producer on the four corpora: every body read (--produce) with the default warnings, read as
# -c reads a unit, and with -Wall -Wextra; and as a compile would run it (--produce-lean) with the default warnings and read
# as -c reads a unit. Each run's sums in OUT/reduced.txt.
cc=$1; out=$2
b=$(dirname "$0")
mkdir -p "$out"
: > "$out/reduced.txt"
for run in "full-default:--produce:" "lean-default:--produce-lean:" "full-controls:--produce:--statement-controls" "lean-controls:--produce-lean:--statement-controls" "full-wall:--produce:-Wall -Wextra"; do
    name=${run%%:*}; rest=${run#*:}; mode=${rest%%:*}; extra=${rest#*:}
    echo "== $name" >> "$out/reduced.txt"
    bash "$b/produce.sh" "$cc" "$out/$name" "$mode" $extra 2>&1 | grep " exit " >> "$out/reduced.txt"
    python3 "$b/produce-reduce.py" "$out/$name"/{sqlite,lua,main,musl}.txt >> "$out/reduced.txt"
done
echo done >> "$out/reduced.txt"
