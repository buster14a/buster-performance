#!/bin/bash
# med.sh DIR PREFIX STAGE...: median ms of each stage over DIR/PREFIX-*.err
dir=$1; prefix=$2; shift 2
for st in "$@"; do
  v=$(for f in $dir/$prefix-*.err; do awk -F'\t' -v s="$st" '$1=="time-stage" && $2==s {print $3}' $f; done | sort -n | awk '{a[NR]=$1} END {if (NR) print a[int((NR+1)/2)]}')
  printf "%s=%s " $st "$v"
done; echo
