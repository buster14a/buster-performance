#!/usr/bin/env bash
# rip.sh DIR: rip-relative leas in DIR's five TSVs, by function and target, and whole-process totals.
d=$1
gawk -F'\t' '$1=="#ins" && $5=="lea" && $7 ~ /\(%rip\)/ { x=$7; t=x; sub(/^.*</, "", t); sub(/>.*$/, "", t); k=$2 " -> " t; c[k]+=$6; all+=$6 }
END { printf "rip leas %.1f M\n", all/1e6; for (k in c) if (c[k] > 500000) printf "  %8.1f M  %s\n", c[k]/1e6, k }' $d/{calls,tables,strings,arithmetic,closures}.tsv | sort -k1,1 -t' ' 
