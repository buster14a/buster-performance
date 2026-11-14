#!/usr/bin/env bash
# functions.sh A B [threshold]: per function, the instructions callgrind counted (gap.c's #ins rows) in A's TSVs and B's,
# and those that differ by more than threshold (default 50,000), sorted by the difference.
a=$1; b=$2; t=${3:-50000}
sum() { eval cat $1 | awk -F'\t' '$1=="#ins" { s[$2]+=$6 } END { for (f in s) print f "\t" s[f] }'; }
join -t $'\t' -a1 -a2 -e 0 -o 0,1.2,2.2 <(sum "$a" | sort) <(sum "$b" | sort) | awk -F'\t' -v t=$t '{ d=$3-$2; if (d > t || d < -t) printf "%+10.3f M  %12.3f M  %12.3f M  %s\n", d/1e6, $2/1e6, $3/1e6, $1 }' | sort -n
