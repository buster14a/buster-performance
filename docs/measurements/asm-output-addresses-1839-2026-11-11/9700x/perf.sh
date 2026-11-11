#!/bin/bash
# #1839 item 7: store-to-load forwarding of asm bodies' output addresses (main's compiler, Tier 0).
D=$HOME/buster-fast-bench/1839-b5b-claude
cd $D
export EXCLUSIVE_OWNER=claude-b5b EXCLUSIVE_TITLE="B5b: asm output addresses (#1839 item 7)" EXCLUSIVE_LINK=https://claude.ai/code/session_01Egbxncm5H7M1xEYvq9LNCT
./base/build/compiler -o out-base out.c
clang -O0 -o out-clang out.c
for v in base clang; do
  ~/buster-fast-bench/exclusive.sh perf stat -x, -e cycles,instructions,ls_bad_status2.stli_other taskset -c 2 ./out-$v > perf-$v.out 2> perf-$v.csv
done
echo done > perf-status
