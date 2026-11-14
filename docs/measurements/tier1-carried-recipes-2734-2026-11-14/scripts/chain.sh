#!/usr/bin/env bash
# chain.sh: compilers.sh, objects.sh, link.sh, time2.sh, the analysis and compile.sh in turn. Started detached by
# systemd-run --user; chain.log says how far it got.
W=$HOME/buster-fast-bench/2734-claude
cd $W || exit 1
step() { echo "$(date -u +%FT%TZ) $1 start" >> chain.log; ./$1 && echo "$(date -u +%FT%TZ) $1 done" >> chain.log || { echo "$(date -u +%FT%TZ) $1 FAILED" >> chain.log; exit 1; }; }
step compilers.sh
step objects.sh
step link.sh
step time2.sh
cc -O2 -o analyze analyze.c -lm
./analyze < runs/runs.txt > analysis.txt 2>&1
echo "$(date -u +%FT%TZ) analysis done" >> chain.log
step compile.sh
echo "$(date -u +%FT%TZ) chain done" >> chain.log
