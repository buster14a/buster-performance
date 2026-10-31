#!/bin/bash
# classify.sh TIER0 TIER1: each function's name and whether its mnemonics differ between the two builds (Tier 1's code)
# or not (Tier 0's in both).
mnemonics() { objdump -d --no-show-raw-insn "$1" | awk '/^[0-9a-f]+ <[^>]+>:$/ { name = substr($2, 2, length($2) - 3); next } NF >= 2 && name != "" { sub(/^ *[0-9a-f]+:\t/, ""); split($0, f, /[ \t]+/); print name "\t" f[1] }'; }
mnemonics "$1" | awk -F'\t' '{ seq[$1] = seq[$1] " " $2 } END { for (n in seq) print n "\t" seq[n] }' | sort > /tmp/claude-classify-0.txt
mnemonics "$2" | awk -F'\t' '{ seq[$1] = seq[$1] " " $2 } END { for (n in seq) print n "\t" seq[n] }' | sort > /tmp/claude-classify-1.txt
join -t $'\t' /tmp/claude-classify-0.txt /tmp/claude-classify-1.txt | awk -F'\t' '{ print $1 "\t" ($2 == $3 ? "tier0" : "tier1") }'
