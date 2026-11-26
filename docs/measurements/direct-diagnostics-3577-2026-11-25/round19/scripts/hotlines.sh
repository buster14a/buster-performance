#!/bin/bash
# hotlines.sh: per-function hot 64-byte code lines from the cycle profiles (pcyc-base.data, pcyc-work.data).
cd ~/buster-fast-bench/3577-claude || exit 1
for t in base work; do
  perf script -i pcyc-$t.data -F ip,sym 2>/dev/null | awk '{print $1, $2}' > hl-$t.txt
done
for t in base work; do
  awk -v T=$t '{ip=strtonum("0x"$1); line=int(ip/64); n[line]++; s[line]=$2; total++}
    END {
      for (l in n) { hot1++; if (n[l] >= 20) hot20++; if (n[l] >= 100) hot100++; fs[s[l]]++; if (n[l] >= 20) fh[s[l]]++; fw[s[l]] += n[l] }
      printf "%s: samples %d, lines touched %d, >=20 samples %d, >=100 samples %d\n", T, total, hot1, hot20, hot100
      for (f in fs) printf "F\t%s\t%s\t%d\t%d\t%d\n", T, f, fs[f], fh[f], fw[f]
    }' hl-$t.txt
done > hl-sum.txt
grep -v "^F" hl-sum.txt
# per function: lines>=20 base vs work, sorted by growth
awk -F'\t' '$1=="F"{k=$3; if ($2=="base") {b[k]=$5; bw[k]=$6} else {w[k]=$5; ww[k]=$6}; seen[k]=1}
  END {for (k in seen) printf "%+5d\t%5d\t%5d\t%+7d\t%s\n", w[k]-b[k], b[k], w[k], ww[k]-bw[k], k}' hl-sum.txt | sort -t$'\t' -k1,1nr | head -40
echo ---
awk -F'\t' '$1=="F"{k=$3; if ($2=="base") {b[k]=$5} else {w[k]=$5}; seen[k]=1}
  END {for (k in seen) {tb+=b[k]; tw+=w[k]}; printf "total hot lines (>=20): base %d work %d\n", tb, tw}' hl-sum.txt
