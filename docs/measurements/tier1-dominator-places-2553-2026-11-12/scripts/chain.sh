#!/usr/bin/env bash
# chain.sh: compilers.sh, prepare.sh and time.sh in turn (each holds the lock per run), then the analysis of each
# revision against base. Started detached; chain.log says how far it got.
W=$HOME/buster-fast-bench/2553-claude
cd $W || exit 1
echo "$(date -u +%FT%TZ) chain start" >> chain.log
./compilers.sh && echo "$(date -u +%FT%TZ) compilers done" >> chain.log || { echo "$(date -u +%FT%TZ) compilers FAILED" >> chain.log; exit 1; }
./prepare.sh && echo "$(date -u +%FT%TZ) prepare done" >> chain.log || { echo "$(date -u +%FT%TZ) prepare FAILED" >> chain.log; exit 1; }
OUT=runs ./time.sh && echo "$(date -u +%FT%TZ) time done" >> chain.log || { echo "$(date -u +%FT%TZ) time FAILED" >> chain.log; exit 1; }
cc -O2 -o analyze analyze.c -lm
for h in h7 h11; do
    awk -v h=$h '$4 == "base" || $4 == h { if ($4 == h) $4 = "head"; print }' runs/runs.txt | ./analyze > analysis-$h.txt 2>&1
done
echo "$(date -u +%FT%TZ) chain done" >> chain.log
