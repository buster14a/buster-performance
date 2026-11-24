#!/usr/bin/env bash
# chain.sh: compilers.sh, objects.sh, compile.sh, link.sh, time2.sh and the analysis in turn; started detached by
# systemd-run --user; chain.log says how far it got.
W=$HOME/buster-fast-bench/2553-claude-slots
cd $W || exit 1
step() { echo "$(date -u +%FT%TZ) $1 start" >> chain.log; ./$1 && echo "$(date -u +%FT%TZ) $1 done" >> chain.log || { echo "$(date -u +%FT%TZ) $1 FAILED" >> chain.log; exit 1; }; }
step compilers.sh
step objects.sh
step compile.sh
step link.sh
step time2.sh
cc -O2 -o analyze analyze.c -lm
./analyze < runs/runs.txt > analysis.txt 2>&1
echo "$(date -u +%FT%TZ) chain done" >> chain.log
