#!/usr/bin/env bash
# chain2.sh: rehead.sh, profile.sh, objects.sh, compile.sh, link.sh, time2.sh and the analysis in turn.
W=$HOME/buster-fast-bench/2774-claude
cd $W || exit 1
step() { echo "$(date -u +%FT%TZ) $1 start" >> chain.log; ./$1 && echo "$(date -u +%FT%TZ) $1 done" >> chain.log || { echo "$(date -u +%FT%TZ) $1 FAILED" >> chain.log; exit 1; }; }
[ -d compile ] && mv compile compile-245ad06
HEAD_SHA=23d0c3cfd9021abed4930306033dc1b21559f179 step rehead.sh
step profile.sh
step objects.sh
step compile.sh
step link.sh
step time2.sh
cc -O2 -o analyze analyze.c -lm
./analyze < runs/runs.txt > analysis.txt 2>&1
echo "$(date -u +%FT%TZ) chain done" >> chain.log
