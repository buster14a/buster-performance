#!/bin/bash
# #2677's 9700X measurements after round 1: rounds 2-6 and 7-11 (two holds), then sqlite3.c's --tier1 -c (11 runs).
cd ~/buster-fast-bench/2677-claude || exit 1
echo $$ > run-rest.pid
kernels/rounds.sh 2 6 >> kernels/measure.log 2>&1
kernels/rounds.sh 7 11 >> kernels/measure.log 2>&1
compile/compile.sh 11 "main=$PWD/main" "head=$PWD/head" > compile/compile.log 2>&1
echo all done
