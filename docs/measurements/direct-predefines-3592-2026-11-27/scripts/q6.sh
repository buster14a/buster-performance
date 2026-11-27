#!/bin/bash
d=~/buster-fast-bench/3586-claude2
cd $d
export EXCLUSIVE_OWNER=claude-3586 EXCLUSIVE_TITLE="Direct path predefines (#3586/#3592)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3586
~/buster-fast-bench/exclusive.sh timeout -k 5 600 ./build-variant.sh batch batch.patch
for u in add hello wcwidth six; do
    ~/buster-fast-bench/exclusive.sh timeout -k 5 300 ./ab-loop.sh 11 100 $u main lazy batch > results/ab-batch-$u.txt 2>&1
done
~/buster-fast-bench/exclusive.sh timeout -k 5 400 ./ab-loop.sh 11 3 sqlite main lazy batch > results/ab-batch-sqlite.txt 2>&1
echo Q6-DONE
