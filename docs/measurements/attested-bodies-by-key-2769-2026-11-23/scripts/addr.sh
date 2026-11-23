#!/bin/bash
# addr.sh BINARY ANNOTATION: each sampled instruction's share by its innermost source line (addr2line), summed.
bin=$1; ann=$2
grep -E '^ +[0-9]+\.[0-9]+ : +[0-9a-f]+:' "$ann" | awk '$1 > 0 {print $1, $3}' | sed 's/:$//' > /tmp/addr-$$.txt
cut -d' ' -f2 /tmp/addr-$$.txt | sed 's/^/0x/' | llvm-addr2line -e "$bin" > /tmp/lines-$$.txt 2>/dev/null || cut -d' ' -f2 /tmp/addr-$$.txt | sed 's/^/0x/' | addr2line -e "$bin" > /tmp/lines-$$.txt
paste -d' ' /tmp/addr-$$.txt /tmp/lines-$$.txt | awk '{split($3, a, "/"); key=a[length(a)]; s[key]+=$1} END {for (k in s) printf "%6.2f %s\n", s[k], k}' | sort -rn | head -${TOP:-25}
rm -f /tmp/addr-$$.txt /tmp/lines-$$.txt
