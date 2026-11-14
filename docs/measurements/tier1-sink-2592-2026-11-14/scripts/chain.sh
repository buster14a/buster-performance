#!/usr/bin/env bash
# chain.sh: compilers.sh, prepare.sh, time.sh and compile.sh in turn (each holds the lock per run), then the analysis
# of head against base. Started detached; chain.log says how far it got.
W=$HOME/buster-fast-bench/2592-claude
cd $W || exit 1
echo "$(date -u +%FT%TZ) chain start" >> chain.log
./compilers.sh && echo "$(date -u +%FT%TZ) compilers done" >> chain.log || { echo "$(date -u +%FT%TZ) compilers FAILED" >> chain.log; exit 1; }
for t in base head; do test -x $W/$t/build/compiler || { echo "$(date -u +%FT%TZ) $t compiler missing" >> chain.log; exit 1; }; done
./prepare.sh && echo "$(date -u +%FT%TZ) prepare done" >> chain.log || { echo "$(date -u +%FT%TZ) prepare FAILED" >> chain.log; exit 1; }
OUT=runs ./time.sh && echo "$(date -u +%FT%TZ) time done" >> chain.log || { echo "$(date -u +%FT%TZ) time FAILED" >> chain.log; exit 1; }
cc -O2 -o analyze analyze.c -lm
./analyze < runs/runs.txt > analysis.txt 2>&1
echo "$(date -u +%FT%TZ) analysis done" >> chain.log
./compile.sh && echo "$(date -u +%FT%TZ) compile done" >> chain.log
echo "$(date -u +%FT%TZ) chain done" >> chain.log
