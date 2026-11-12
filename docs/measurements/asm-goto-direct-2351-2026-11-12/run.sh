#!/bin/bash
# #2351 gap 1: suites on head, then base (main e943360f) vs head on B5b's asm goto kernel, 7 runs each alternating, CPU 2.
D=$HOME/buster-fast-bench/2351-claude-e3c
cd $D
export EXCLUSIVE_OWNER=claude-e3c EXCLUSIVE_TITLE="E3c: asm goto direct branches (#2351)" EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxngRG2JubXSLsHFAZpg
X=~/buster-fast-bench/exclusive.sh
[ -d base ] || git clone -q https://github.com/buster14a/buster base
(cd base && git checkout -q e943360f)
$X ./build.sh > build-head.log 2>&1; echo "build head $?" >> status
(cd base && $X ./build.sh > ../build-base.log 2>&1); echo "build base $?" >> status
for t in "test-checker-asm" "test-checker --program-asm" "test-tier0 --cross-check" "test-tier0-inline" "test-object-writer --cross-check" "test-link" "test-check-lanes" "test-check-units" "test-checker"; do
  $X bash -c "./build/compiler $t > 'test-${t// /_}.log' 2>&1"; echo "$t $? $(tail -1 "test-${t// /_}.log")" >> status
done
for v in base head; do b=$([ $v = base ] && echo base/build/compiler || echo build/compiler); $b -o goto-$v goto.c; objdump -d --no-show-raw-insn goto-$v | awk '/<sign>:/,/^$/' > sign-$v.s; done
echo "variant run ns result" > times.tsv
for r in 1 2 3 4 5 6 7; do for v in base head; do
  $X bash -c "s=\$(date +%s%N); out=\$(taskset -c 2 ./goto-$v); e=\$(date +%s%N); echo $v $r \$((e - s)) \$out" >> times.tsv
done; done
echo done >> status
