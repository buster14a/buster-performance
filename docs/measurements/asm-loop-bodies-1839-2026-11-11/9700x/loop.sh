#!/bin/bash
# #1839 item 4: loop and jrcxz as asm bodies (head) against the whole assembler's helpers (base), on the 9700X.
D=$HOME/buster-fast-bench/1839-b5b-claude
cd $D
export EXCLUSIVE_OWNER=claude-b5b EXCLUSIVE_TITLE="B5b: loop and jrcxz as asm bodies (#1839 item 4)" EXCLUSIVE_LINK=https://claude.ai/code/session_01Egbxncm5H7M1xEYvq9LNCT
for v in base4 head4; do
  rev=$(cat $v.rev)
  [ -d $v ] || git clone -q https://github.com/buster14a/buster $v
  (cd $v && git fetch -q origin $rev && git checkout -q $rev)
  (cd $v && ~/buster-fast-bench/exclusive.sh ./build.sh > ../build-$v.log 2>&1)
  ./$v/build/compiler -o loop-$v loop.c
  objdump -d --no-show-raw-insn loop-$v | awk '/<sum>:/,/^$/' > sum-$v.s
done
echo "variant run ns result" > loop-times.tsv
for r in 1 2 3 4 5; do for v in base4 head4; do
  ~/buster-fast-bench/exclusive.sh bash -c "s=\$(date +%s%N); out=\$(taskset -c 2 ./loop-$v); e=\$(date +%s%N); echo $v $r \$((e - s)) \$out" >> loop-times.tsv
done; done
echo done > loop-status
