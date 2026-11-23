#!/bin/bash
# Usage: abtable.sh DIR: the medians of the row's stages for a/ and b/ (ms), b - a, and each side's least and most.
DIR=$1
row_a=0; row_b=0
for s in lower lower.validate tier0 emit-setup branch-sizing encode unwind code-atoms publish-data object-build object-write total; do
  a=$(grep -h -P "^time-stage\t$s\t" $DIR/a/stages-*.txt | awk '{print $3}' | sort -n | awk '{v[NR]=$1} END {printf "%s %s %s", v[int((NR+1)/2)], v[1], v[NR]}')
  b=$(grep -h -P "^time-stage\t$s\t" $DIR/b/stages-*.txt | awk '{print $3}' | sort -n | awk '{v[NR]=$1} END {printf "%s %s %s", v[int((NR+1)/2)], v[1], v[NR]}')
  echo "$s $a $b" | awk '{ printf "%-16s %9.3f %9.3f %+9.3f   a %.3f..%.3f  b %.3f..%.3f\n", $1, $2, $5, $5 - $2, $3, $4, $6, $7 }'
done
for side in a b; do
  for f in $DIR/$side/stages-*.txt; do
    awk -F'\t' '$1 == "time-stage" && ($2 == "tier0" || $2 == "emit-setup" || $2 == "branch-sizing" || $2 == "encode" || $2 == "unwind" || $2 == "code-atoms" || $2 == "publish-data" || $2 == "object-build" || $2 == "object-write") { s += $3 } END { print s }' $f
  done | sort -n | awk -v side=$side '{v[NR]=$1} END {printf "row(%s) %9.3f   %.3f..%.3f\n", side, v[int((NR+1)/2)], v[1], v[NR]}'
done
