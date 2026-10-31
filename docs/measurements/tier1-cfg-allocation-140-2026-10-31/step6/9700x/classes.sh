#!/usr/bin/env bash
# classes.sh TIER0 TIER1: each function of the two builds of one program, "tier1" where its instruction sequence (the
# mnemonics and operands, addresses dropped) differs between them, "tier0" where it doesn't.
set -u
for b in "$1" "$2"; do
    objdump -d --no-show-raw-insn "$b" | awk '
        /^[0-9a-f]+ <.*>:$/ { if (name != "") print name "\t" body; name = substr($2, 2, length($2) - 3); body = ""; next }
        /^ +[0-9a-f]+:/ { sub(/^ +[0-9a-f]+:\t/, ""); gsub(/[0-9a-f]+ <[^>]*>/, "T"); gsub(/0x[0-9a-f]+\(%rip\)/, "R"); body = body ";" $0 }
        END { if (name != "") print name "\t" body }' | LC_ALL=C sort > "$b.functions"
done
LC_ALL=C join -t $'\t' "$1.functions" "$2.functions" | awk -F'\t' '{ print $1 "\t" ($2 == $3 ? "tier0" : "tier1") }'
