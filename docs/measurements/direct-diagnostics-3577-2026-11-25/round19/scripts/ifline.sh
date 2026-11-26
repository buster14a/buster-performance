#!/bin/bash
# ifline.sh: IBS fetch statistics per source line (innermost inlined frame) of base and work, with each line's text.
cd ~/buster-fast-bench/3577-claude || exit 1
A2L=$(command -v llvm-addr2line-23 || command -v llvm-addr2line || command -v addr2line)
for t in base work; do
  awk '{print $1}' if-samples-$t.txt | sort -u > if-addrs-$t.txt
  $A2L -e $t/build/compiler < if-addrs-$t.txt > if-lines-$t.raw
  paste -d' ' if-addrs-$t.txt if-lines-$t.raw > if-addrline-$t.txt
  awk -v T=$t -v R="$PWD/$t/" 'NR == FNR { m[$1] = $2; next }
    { k = m[$1]; if (k == "") k = "?"; N[k]++; L[k] += $2; I[k] += $4; O[k] += $5 }
    END { for (k in N) printf "%d\t%d\t%d\t%d\t%s\n", I[k] + O[k], I[k], O[k], N[k], k }' if-addrline-$t.txt if-samples-$t.txt | sort -k1,1nr > if-byline-$t.txt
  # attach text
  awk -F'\t' -v R="$PWD/$t/" '{ split($5, p, ":"); f = p[1]; ln = p[2] + 0; sub(/ .*/, "", ln); txt = ""; if (f ~ /c_direct/ && ln > 0) { cmd = "sed -n " ln "p " f; cmd | getline txt; close(cmd) } gsub(/^[ \t]+/, "", txt); printf "%s\t%s\n", $0, substr(txt, 1, 140) }' if-byline-$t.txt | head -300 > if-byline-text-$t.txt
done
head -3 if-addrline-work.txt
wc -l if-byline-*.txt
