#!/bin/bash
# compare.sh DIR: the bytes of the functions DIR's --tier1 compiled by Tier 1 (not refused) that clang -O0 also emits,
# against clang -O0's, per object file (static functions keyed by file).
d=$1
c=~/.cache/claude-1116/clang0
grep -o "tier1-refused	[^	]*" $d/report.txt | cut -f2 | sort -u > /tmp/claude-1116-refused-names.txt
for o in $d/*.o; do b=$(basename $o); nm -S $o | awk -v f=$b '$3 ~ /^[tT]$/ && NF==4 {print f":"$4, strtonum("0x"$2)}'; done | sort > /tmp/claude-1116-t1.txt
for o in $c/*.o; do b=$(basename $o); nm -S $o | awk -v f=$b '$3 ~ /^[tT]$/ && NF==4 {print f":"$4, strtonum("0x"$2)}'; done | sort > /tmp/claude-1116-c0.txt
join /tmp/claude-1116-t1.txt /tmp/claude-1116-c0.txt | awk 'BEGIN{while ((getline l < "/tmp/claude-1116-refused-names.txt") > 0) r[l]=1} {split($1,p,":"); if (!(p[2] in r)) {n++; a+=$2; b+=$3}} END{printf "functions=%d tier1=%d clang0=%d ratio=%.3f\n", n, a, b, a/b}'
