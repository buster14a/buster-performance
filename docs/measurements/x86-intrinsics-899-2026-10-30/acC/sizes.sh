#!/bin/bash
# acC's two builds' .rodata and .text, the effects rows' table's copies and sizes, and the read-only data symbols whose
# total size (over every copy of one name) differs, largest last.
cd ~/buster-fast-bench/claude-126-cloud/acC
for t in base h9f; do
    echo "$t: $(readelf -SW $t/build/compiler | awk '$2 == ".rodata" || $2 == ".text" {printf "%s at %s, 0x%s bytes; ", $2, $4, $6}')"
    echo "$t: $(nm -S $t/build/compiler | grep -c ' x86_effects_rows$') copies of x86_effects_rows, each 0x$(nm -S $t/build/compiler | awk '$4 == "x86_effects_rows" {print $2}' | sort -u | tr -d '\n') bytes"
    nm -S $t/build/compiler | awk '$3 == "r" || $3 == "R" {total[$4] += strtonum("0x" $2); count[$4] += 1} END {for (n in total) print n, total[n], count[n]}' | sort > /tmp/claude-126-acC-$t.sizes
done
echo "read-only symbols whose total size differs (head less base, bytes; name; copies in base and in the head):"
join -a1 -a2 -e 0 -o 0,1.2,2.2,1.3,2.3 /tmp/claude-126-acC-base.sizes /tmp/claude-126-acC-h9f.sizes | awk '$2 != $3 {print $3 - $2, $1, $4, $5}' | sort -n
rm -f /tmp/claude-126-acC-base.sizes /tmp/claude-126-acC-h9f.sizes
