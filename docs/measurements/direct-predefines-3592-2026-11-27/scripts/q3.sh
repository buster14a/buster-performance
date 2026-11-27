#!/bin/bash
d=~/buster-fast-bench/3586-claude2
cd $d
while pgrep -f '[q]2.sh' > /dev/null; do sleep 5; done
export EXCLUSIVE_OWNER=claude-3586 EXCLUSIVE_TITLE="Direct path arena tables (#3586)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3586
NO_TEST=1 ~/buster-fast-bench/exclusive.sh timeout -k 5 600 ./build-variant.sh count count.patch
NO_TEST=1 ~/buster-fast-bench/exclusive.sh timeout -k 5 600 ./build-variant.sh e1count count.patch e1.patch
~/buster-fast-bench/exclusive.sh timeout -k 5 600 ./build-variant.sh e1 e1.patch
printf 'int add(int a, int b) { return a + b; }\n' > /dev/shm/q3-add.c
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
for b in count e1count; do echo "== $b"; BUSTER_DIRECT_COUNT=1 bin/compiler-$b --lanes 1 --predefines $C/provenance/gnu17-pinned-predefines.txt -c /dev/shm/q3-add.c -o /dev/shm/q3-add.o; done > results/count-add.txt 2>&1
~/buster-fast-bench/exclusive.sh timeout -k 5 300 ./ab-loop.sh 11 100 add main e1 > results/ab-e1-add.txt 2>&1
echo Q3-DONE
