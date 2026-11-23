#!/bin/bash
# Usage: table.sh DIR: medians of the row's stages and lower's laps over DIR/stages-*.txt (ms).
DIR=$1
for s in lower lower.bodies lower.validate tier0 total; do
  printf '%s\t' $s
  grep -h -P "^time-stage\t$s\t" $DIR/stages-*.txt | awk '{print $3}' | sort -n | awk '{a[NR]=$1} END {print a[int((NR+1)/2)]}'
done
cat $DIR/object.sha256 | cut -c1-16
