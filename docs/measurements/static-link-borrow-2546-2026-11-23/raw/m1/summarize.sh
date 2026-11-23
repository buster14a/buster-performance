#!/bin/sh
# summarize.sh RESULTS NAME... : medians of perf stat and --time-stages per binary.
r=$1; shift
med() { sort -n | awk '{a[NR]=$1} END {if (NR%2) print a[(NR+1)/2]; else print (a[NR/2]+a[NR/2+1])/2}'; }
printf 'name\tprocess-ms\tcycles-u-M\tcycles-k-M\tinstr-u-M\tfaults\truntime-ms\texecutable-ms\texe-faults\texe-kb\twrite-ms\twrite-faults\tlink-ms\n'
for n in "$@"; do
  t=$(cat $r/$n.*.perf | awk -F, '$3=="task-clock"{print $1}' | med)
  cu=$(cat $r/$n.*.perf | awk -F, '$3=="cycles:u"{print $1/1e6}' | med)
  ck=$(cat $r/$n.*.perf | awk -F, '$3=="cycles:k"{print $1/1e6}' | med)
  iu=$(cat $r/$n.*.perf | awk -F, '$3=="instructions:u"{print $1/1e6}' | med)
  pf=$(cat $r/$n.*.perf | awk -F, '$3=="page-faults"{print $1}' | med)
  st() { cat $r/$n.*.ts | awk -F'\t' -v s="$1" -v c="$2" '$1=="time-stage" && $2==s {print $c}' | med; }
  lk=$(for f in $r/$n.*.ts; do awk -F'\t' '$1=="time-stage" && ($2=="runtime"||$2=="executable"||$2=="write") {s+=$3} END {print s}' $f; done | med)
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' $n $t $cu $ck $iu $pf $(st runtime 3) $(st executable 3) $(st executable 6) $(st executable 7) $(st write 3) $(st write 6) $lk
done
