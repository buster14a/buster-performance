cd ~/buster-fast-bench/1340-droid/root/results/zen5-9700x
for w in ab1340b:sq-c ab1340b-self:self-syn; do
  d=${w%%:*}; n=${w#*:}
  for b in pre1049-znver5 main-znver5 walks-znver5 znver5; do
    for f in "$d/logs/$b:$n".r*.log; do awk -v b="$b" -F'\t' '$1=="time-stage" && $2!="stage" {print b "\t" $2 "\t" $3}' "$f"; done
  done | sort -t$'\t' -k1,1 -k2,2 -k3,3g | awk -F'\t' -v n="$n" '{k=$1 "\t" $2; v[k]=v[k] " " $3; c[k]++} END {for (k in v) {split(substr(v[k],2), a, " "); m=a[int((c[k]+1)/2)]; print n "\t" k "\t" m "\t" c[k]}}' | sort
done
