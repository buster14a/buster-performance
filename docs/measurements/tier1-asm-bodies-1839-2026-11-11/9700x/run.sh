#!/bin/bash
# #1839 item 11: Tier 1 asm bodies (#1944) against Tier 1's helpers, on the 9700X. One binary (main 457c589, znver5
# Release, built in the session's container), the same kernels as asm-bodies-1839-2026-11-09. One lock hold.
set -eu
cd "$(dirname "$0")"
C=./compiler
$C --tier1 --tier1-report -o k-t1 kernels.c 2> report-t1.txt
$C --tier1 --tier1-report --helper-forms=asm -o k-t1h kernels.c 2> report-t1h.txt
$C -o k-t0 kernels.c
clang -O0 -o k-clang kernels.c
for k in rdtsc cpuid flags shift x87 mul; do for v in t1 t1h t0 clang; do ./k-$v $k 1000; done | uniq -c | awk '$1!=4{print "MISMATCH"; exit 1}'; done
for v in t1 t1h t0; do echo "$v text=$(size -A k-$v | awk '$1==".text"{print $2}') calls=$(objdump -d k-$v | awk '/<k_[a-z0-9]*>:/,/^$/' | grep -c call)"; done > sizes.txt
: > kernels.tsv
for r in $(seq 7); do
  for k in rdtsc cpuid flags shift x87 mul; do
    n=100000000; [ $k = rdtsc ] && n=20000000; [ $k = cpuid ] && n=2000000; [ $k = x87 ] && n=20000000
    for v in t1 t1h t0; do s=$(date +%s%N); taskset -c 2 ./k-$v $k $n > /dev/null; e=$(date +%s%N); echo "$k $v $r $(( (e-s)/1000 ))" >> kernels.tsv; done
  done
done
for k in shift flags mul; do for v in t1 t1h; do echo "== perf $k $v"; taskset -c 2 perf stat -x, -e cycles,instructions,ls_bad_status2.stli_other ./k-$v $k 100000000 2>&1 >/dev/null | cut -d, -f1,3; done; done
summarize() { awk '{k=$1" "$2; v[k]=v[k]" "$4} END{for(k in v){n=split(v[k],a," "); asort(a); print k, a[int((n+1)/2)], a[1], a[n]}}' "$1" | sort; }
echo "== kernels (median min max us)"; summarize kernels.tsv
