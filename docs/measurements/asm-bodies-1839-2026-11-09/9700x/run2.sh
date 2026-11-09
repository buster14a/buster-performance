#!/bin/bash
# #1839 re-measure: #1866's head 1bfcb90 (asm bodies with register arguments), znver5 binary built in the session's
# container, against base main and head's --helper-forms=asm. One lock hold.
set -eu
cd "$(dirname "$0")"
H=head2/build/compiler; B=base/build/compiler
$H -o k-head2 kernels.c; $H --helper-forms=asm -o k-helpers2 kernels.c; $B -o k-base kernels.c
for k in rdtsc cpuid flags shift x87 mul; do for v in head2 helpers2 base; do ./k-$v $k 1000; done | uniq -c | awk '$1!=3{print "MISMATCH"; exit 1}'; done
: > kernels2.tsv; : > compile2.tsv
for r in $(seq 7); do
  for k in rdtsc cpuid flags shift x87 mul; do
    n=100000000; [ $k = rdtsc ] && n=20000000; [ $k = cpuid ] && n=2000000; [ $k = x87 ] && n=20000000
    for v in head2 helpers2 base; do s=$(date +%s%N); taskset -c 2 ./k-$v $k $n > /dev/null; e=$(date +%s%N); echo "$k $v $r $(( (e-s)/1000 ))" >> kernels2.tsv; done
  done
  for t in base head2; do s=$(date +%s%N); taskset -c 2 $t/build/compiler -c -march=native -Ibase/src -fwrapv -funsigned-char -fno-strict-aliasing -o /tmp/1839-$t.o base/src/buster/compiler/main.c; e=$(date +%s%N); echo "main.c $t $r $(( (e-s)/1000 ))" >> compile2.tsv; done
done
for v in head2 helpers2; do echo "== perf $v"; taskset -c 2 perf stat -x, -e cycles,instructions,ls_bad_status2.stli_other ./k-$v shift 100000000 2>&1 >/dev/null | cut -d, -f1,3; done
summarize() { awk '{k=$1" "$2; v[k]=v[k]" "$4} END{for(k in v){n=split(v[k],a," "); asort(a); print k, a[int((n+1)/2)], a[1], a[n]}}' "$1" | sort; }
echo "== kernels (median min max us)"; summarize kernels2.tsv; echo "== compile"; summarize compile2.tsv
