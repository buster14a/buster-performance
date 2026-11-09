#!/bin/bash
# #1839's measurement: asm bodies (head) against helper calls (head --helper-forms=asm, and base main), on the 9700X.
# Each block takes the lock alone (exclusive.sh per run). Usage: run.sh BASE_SHA HEAD_SHA
set -eu
cd "$(dirname "$0")"
base=$1; head=$2
export EXCLUSIVE_OWNER=claude-1839 EXCLUSIVE_TITLE="#1839 asm bodies measurement" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1839
X=~/buster-fast-bench/exclusive.sh
for tree in base head; do
  sha=$base; [ $tree = head ] && sha=$head
  if [ ! -d $tree ]; then git clone -q https://github.com/buster14a/buster $tree; fi
  git -C $tree fetch -q origin "$sha" 2>/dev/null || git -C $tree fetch -q origin
  git -C $tree checkout -q "$sha"
  (cd $tree && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 $X ./build.sh > ../build-$tree.log 2>&1)
done
B=base/build/compiler; H=head/build/compiler
$H -o k-head kernels.c; $H --helper-forms=asm -o k-helpers kernels.c; $B -o k-base kernels.c
$H -c -o k-head.o kernels.c; $H --helper-forms=asm -c -o k-helpers.o kernels.c; $B -c -o k-base.o kernels.c
for v in head helpers base; do printf "%s text=%s calls=%s\n" $v "$(size -A k-$v.o | awk '/^\.text/{s+=$2}END{print s}')" "$(objdump -d k-$v.o | grep -c 'call ')"; done > sizes.txt
: > kernels.tsv
for k in rdtsc cpuid flags shift x87 mul; do
  n=100000000; [ $k = rdtsc ] && n=20000000; [ $k = cpuid ] && n=2000000; [ $k = x87 ] && n=20000000
  for v in head helpers base; do ./k-$v $k 1000 > out-$k-$v.txt; done
  cmp out-$k-head.txt out-$k-helpers.txt && cmp out-$k-head.txt out-$k-base.txt
  $X bash -c "for r in \$(seq 11); do for v in head helpers base; do s=\$(date +%s%N); taskset -c 2 ./k-\$v $k $n > /dev/null; e=\$(date +%s%N); echo \"$k \$v \$r \$(( (e-s)/1000 ))\" >> kernels.tsv; done; done"
done
FLAGS="-march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing"
: > compile.tsv
for tree in base head; do (cd $tree && ./build/compiler -c $FLAGS -o /tmp/1839-$tree.o src/buster/compiler/main.c); done
$X bash -c "for r in \$(seq 11); do for tree in base head; do s=\$(date +%s%N); (cd \$tree && taskset -c 2 ./build/compiler -c $FLAGS -o /tmp/1839-\$tree.o src/buster/compiler/main.c); e=\$(date +%s%N); echo \"main.c \$tree \$r \$(( (e-s)/1000 ))\" >> compile.tsv; done; done"
$X bash -c "for r in \$(seq 11); do for tree in base head; do s=\$(date +%s%N); taskset -c 2 \$tree/build/compiler -c -o /tmp/1839-k-\$tree.o kernels.c; e=\$(date +%s%N); echo \"kernels.c \$tree \$r \$(( (e-s)/1000 ))\" >> compile.tsv; done; done"
summarize() { awk '{k=$1" "$2; v[k]=v[k]" "$4} END{for(k in v){n=split(v[k],a," "); asort(a); print k, a[int((n+1)/2)]}}' "$1" | sort; }
{ echo "== kernels (median us)"; summarize kernels.tsv; echo "== compile (median us)"; summarize compile.tsv; echo "== sizes"; cat sizes.txt; } > summary.txt
cat summary.txt
