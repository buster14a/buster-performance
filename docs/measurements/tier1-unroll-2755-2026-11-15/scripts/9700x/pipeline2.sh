#!/usr/bin/env bash
# pipeline2.sh: after pipeline.sh's x86-64 matrix, with the lock's queue some 20 sessions deep, the compile-cost rounds
# first (compile/compile.sh), then the znver5 kernels (loops/measure.sh znver5), then the programs (programs.sh).
set -u
cd ~/buster-fast-bench/2755-claude || exit 1
echo "start $(date -u +%FT%TZ)" > pipeline2.log
(cd compile && ./compile.sh > compile.log 2>&1)
echo "compiled $(date -u +%FT%TZ)" >> pipeline2.log
(cd loops && ./measure.sh znver5 > measure-znver5.log 2>&1)
echo "measured znver5 $(date -u +%FT%TZ)" >> pipeline2.log
./programs.sh > programs.log 2>&1
echo "programs $(date -u +%FT%TZ)" >> pipeline2.log
