#!/bin/bash
# Usage: table.sh DIR: medians of the row's stages (ms) and of the laps (TSC ticks) over DIR/stages-*.txt.
DIR=$1
for s in lower lower.bodies lower.validate tier0 total; do
  printf '%s\t' $s
  grep -h -P "^time-stage\t$s\t" $DIR/stages-*.txt | awk '{print $3}' | sort -n | awk '{a[NR]=$1} END {print a[int((NR+1)/2)]}'
done
for l in $(grep -h '^lap3394' $DIR/stages-1.txt 2>/dev/null | awk '{print $2}'); do
  printf 'lap %s\t' $l
  grep -h "^lap3394 $l " $DIR/stages-*.txt | awk '{print $3, $4}' | sort -n | awk '{a[NR]=$1; c=$2} END {print a[int((NR+1)/2)], c}'
done
cat $DIR/object.sha256 | cut -c1-16
