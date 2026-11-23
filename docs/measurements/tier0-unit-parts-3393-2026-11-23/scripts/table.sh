#!/bin/bash
# Usage: table.sh DIR: the medians of the row's stages over DIR/stages-*.txt (ms).
DIR=$1
for s in tier0 emit-setup branch-sizing encode unwind code-atoms publish-data object-build object-write lower.validate total; do
  printf '%s\t' $s
  grep -h -P "^time-stage\t$s\t" $DIR/stages-*.txt | awk '{print $3}' | sort -n | awk '{a[NR]=$1} END {print a[int((NR+1)/2)]}'
done
grep -h -P "^time-process\ttokens\t" $DIR/stages-1.txt
