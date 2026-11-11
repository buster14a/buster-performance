#!/bin/bash
# #1839 item 2: the asm goto kernel, base (helper) vs head (body), 5 runs each, alternating, pinned to CPU 2.
D=$HOME/buster-fast-bench/1839-b5b-claude
cd $D
export EXCLUSIVE_OWNER=claude-b5b EXCLUSIVE_TITLE="B5b: asm goto as a body (#1839)" EXCLUSIVE_LINK=https://claude.ai/code/session_01Egbxncm5H7M1xEYvq9LNCT
echo "variant run ns result" > times.tsv
for r in 1 2 3 4 5; do for v in base head; do
  ~/buster-fast-bench/exclusive.sh bash -c "s=\$(date +%s%N); out=\$(taskset -c 2 ./goto-$v); e=\$(date +%s%N); echo $v $r \$((e - s)) \$out" >> times.tsv
done; done
for v in base head; do objdump -d --no-show-raw-insn goto-$v | awk '/<sign>:/,/^$/' > sign-$v.s; done
echo done > time-status
