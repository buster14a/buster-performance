#!/bin/bash
d=~/buster-fast-bench/3586-claude2
cd $d
export EXCLUSIVE_OWNER=claude-3586 EXCLUSIVE_TITLE="Direct path predefines (#3586/#3592)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3592
for u in add hello six wcwidth; do
    ~/buster-fast-bench/exclusive.sh timeout -k 5 300 ./ab-loop.sh 11 100 $u main final > results/final-ab-$u.txt 2>&1
done
~/buster-fast-bench/exclusive.sh timeout -k 5 400 ./ab-loop.sh 11 3 sqlite main final > results/final-ab-sqlite.txt 2>&1
BUILDS="lua" ~/buster-fast-bench/exclusive.sh timeout -k 5 500 ./builds-ab.sh 7 main final > results/final-builds-lua.txt 2>&1
MUSL_STD=-std=c99 BUILDS="musl" ~/buster-fast-bench/exclusive.sh timeout -k 5 580 ./builds-ab.sh 5 main final > results/final-builds-musl.txt 2>&1
echo Q8-DONE
