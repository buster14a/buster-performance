#!/bin/bash
# Usage: abtable.sh DIR: the medians of the row's stages for a/ and b/ (ms), and b - a.
DIR=$1
for s in lower lower.validate tier0 emit-setup branch-sizing encode unwind code-atoms publish-data object-build object-write total; do
  a=$(grep -h -P "^time-stage\t$s\t" $DIR/a/stages-*.txt | awk '{print $3}' | sort -n | awk '{v[NR]=$1} END {print v[int((NR+1)/2)]}')
  b=$(grep -h -P "^time-stage\t$s\t" $DIR/b/stages-*.txt | awk '{print $3}' | sort -n | awk '{v[NR]=$1} END {print v[int((NR+1)/2)]}')
  awk -v s=$s -v a=$a -v b=$b 'BEGIN { printf "%-16s %9.3f %9.3f %+9.3f\n", s, a, b, b - a }'
done
