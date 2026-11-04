#!/bin/bash
# #1233: what each checker offset moved. On the host, nm -n -S of every variant executable (var/TREE-N/compiler);
# then, where the record was written, layout_diff.py of each against its tree's offset 0 (logs/layout/variants.txt).
# Usage on the host: variant-layout.sh > nm.tar; locally: tar -xf nm.tar, then the loop below.
R=$HOME/buster-fast-bench/1233-claude
if [ "${1:-}" = local ]; then
    for s in 754475d4 4670b2eb; do for n in 16 32 48 1040 2080 3120 4032; do
        echo "$s offset $n: $(python3 layout_diff.py claude-1233-nm-$s-0.txt claude-1233-nm-$s-$n.txt | grep -v '^new in' | sed -E 's/ +/ /g' | awk '{print $3, "functions", $5, $6}' | tr '\n' ';')"
    done; done
else
    cd $R/var && for d in 754475d4-* 4670b2eb-*; do [ -f $d/compiler ] && nm -n -S $d/compiler > /tmp/claude-1233-nm-$d.txt; done
    cd /tmp && tar -cf - claude-1233-nm-*.txt; for f in /tmp/claude-1233-nm-*.txt; do unlink $f; done
fi
