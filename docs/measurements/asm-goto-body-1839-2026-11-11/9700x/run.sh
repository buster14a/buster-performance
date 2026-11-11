#!/bin/bash
# #1839 item 2: asm goto as a body, base (helper) vs head (body), on the 9700X.
set -e
D=$HOME/buster-fast-bench/1839-b5b-claude
cd $D
export EXCLUSIVE_OWNER=claude-b5b EXCLUSIVE_TITLE="B5b: asm goto as a body (#1839)" EXCLUSIVE_LINK=https://claude.ai/code/session_01Egbxncm5H7M1xEYvq9LNCT
for v in base head; do
  rev=$(cat $v.rev)
  [ -d $v ] || git clone -q https://github.com/buster14a/buster $v
  (cd $v && git fetch -q origin $rev && git checkout -q $rev)
  (cd $v && ~/buster-fast-bench/exclusive.sh ./build.sh > ../build-$v.log 2>&1)
  ./$v/build/compiler -o goto-$v goto.c
done
for v in base head; do objdump -d goto-$v | awk '/<sign>:|<hit>:/,/ret/' | grep -c call > calls-$v.txt || true; done
echo "variant run seconds result" > results.tsv
for r in 1 2 3 4 5; do for v in base head; do
  ~/buster-fast-bench/exclusive.sh bash -c "s=\$(date +%s.%N); out=\$(taskset -c 2 ./goto-$v); e=\$(date +%s.%N); echo $v $r \$(echo \"\$e - \$s\" | bc) \$out" >> results.tsv
done; done
echo done > status
