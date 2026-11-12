#!/bin/bash
# #2144: Tier 1 asm bodies' register operands in registers. --tier1 builds of the #1839 record's kernels by base
# (main c1986fd5) and head, each znver5 Release; Tier 0's (head's default) for reference. One lock hold.
set -eu
cd "$(dirname "$0")"
B=./base/build/compiler; H=./head/build/compiler
$B --tier1 --tier1-report -o k-base kernels.c 2> report-base.txt
$H --tier1 --tier1-report -o k-head kernels.c 2> report-head.txt
$H -o k-t0 kernels.c
clang -O0 -o k-clang kernels.c
for k in rdtsc cpuid flags shift x87 mul; do for v in base head t0 clang; do ./k-$v $k 1000; done | uniq -c | awk '$1!=4{print "MISMATCH"; exit 1}'; done
for v in base head t0; do echo "$v text=$(size -A k-$v | awk '$1==".text"{print $2}') calls=$(objdump -d k-$v | awk '/<k_[a-z0-9]*>:/,/^$/' | grep -c call)"; done > sizes.txt
: > kernels.tsv
for r in $(seq 7); do
  for k in rdtsc cpuid flags shift x87 mul; do
    n=100000000; [ $k = rdtsc ] && n=20000000; [ $k = cpuid ] && n=2000000; [ $k = x87 ] && n=20000000
    for v in base head t0; do s=$(date +%s%N); taskset -c 2 ./k-$v $k $n > /dev/null; e=$(date +%s%N); echo "$k $v $r $(( (e-s)/1000 ))" >> kernels.tsv; done
  done
done
for k in shift flags mul; do for v in base head; do echo "== perf $k $v"; taskset -c 2 perf stat -x, -e cycles,instructions ./k-$v $k 100000000 2>&1 >/dev/null | cut -d, -f1,3; done; done
summarize() { awk '{k=$1" "$2; v[k]=v[k]" "$4} END{for(k in v){n=split(v[k],a," "); asort(a); print k, a[int((n+1)/2)], a[1], a[n]}}' "$1" | sort; }
echo "== kernels (median min max us)"; summarize kernels.tsv
