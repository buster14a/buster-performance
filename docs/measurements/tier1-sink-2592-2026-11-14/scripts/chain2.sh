#!/usr/bin/env bash
# chain2.sh: after compilers.sh and prepare.sh's objects (the first chain, stopped while linking), link.sh, time2.sh,
# the analysis and compile.sh in turn. Started detached; chain.log says how far it got.
W=$HOME/buster-fast-bench/2592-claude
cd $W || exit 1
echo "$(date -u +%FT%TZ) chain2 start" >> chain.log
./link.sh && echo "$(date -u +%FT%TZ) link done" >> chain.log || { echo "$(date -u +%FT%TZ) link FAILED" >> chain.log; exit 1; }
./time2.sh && echo "$(date -u +%FT%TZ) time done" >> chain.log || { echo "$(date -u +%FT%TZ) time FAILED" >> chain.log; exit 1; }
cc -O2 -o analyze analyze.c -lm
./analyze < runs/runs.txt > analysis.txt 2>&1
echo "$(date -u +%FT%TZ) analysis done" >> chain.log
./compile.sh && echo "$(date -u +%FT%TZ) compile done" >> chain.log
echo "$(date -u +%FT%TZ) chain done" >> chain.log
