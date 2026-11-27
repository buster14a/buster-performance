#!/bin/bash
d=~/buster-fast-bench/3586-claude2
cd $d
while pgrep -f '[q]4.sh' > /dev/null; do sleep 5; done
export EXCLUSIVE_OWNER=claude-3586 EXCLUSIVE_TITLE="Direct path predefines (#3586/#3592)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3586
~/buster-fast-bench/exclusive.sh timeout -k 5 600 ./build-variant.sh lazy lazy-float.patch
for u in add hello wcwidth; do
    ~/buster-fast-bench/exclusive.sh timeout -k 5 300 ./ab-loop.sh 11 100 $u main lazy > results/ab-lazy-$u.txt 2>&1
done
~/buster-fast-bench/exclusive.sh timeout -k 5 300 ./ab-loop.sh 11 3 sqlite main lazy > results/ab-lazy-sqlite.txt 2>&1
echo Q5-DONE
