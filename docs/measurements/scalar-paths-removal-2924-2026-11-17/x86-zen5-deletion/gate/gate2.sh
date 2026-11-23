#!/bin/sh
# #2924 x86 tables' twins gate: each module's own two-path benchmark on main 68cc356a4 (+ the semantics batch knob),
# each run under the lock alone, pinned to CPU 2. Fresh copy of the executable.
set -u
cd ~/buster-fast-bench/2924-x86
. ./env.sh
mkdir -p gate-out
cp gate/build/compiler /dev/shm/x86gate-compiler
C=/dev/shm/x86gate-compiler
L=~/buster-fast-bench/exclusive.sh
for round in 1 2 3; do
  $L timeout -k 5 300 taskset -c 2 $C benchmark-x86-zen5 > gate-out/zen5-$round.txt 2>&1
  $L timeout -k 5 300 taskset -c 2 $C benchmark-x86-target > gate-out/target-$round.txt 2>&1
  $L timeout -k 5 300 taskset -c 2 $C benchmark-x86-target --after-predefines 200 > gate-out/target-after-$round.txt 2>&1
done
for batch in 1 2 4 8 16 32 64 96 0; do
  for round in 1 2; do
    $L env BUSTER_GATE_BATCH=$batch timeout -k 5 300 taskset -c 2 $C benchmark-x86-semantics --requests 16384 --functions 512 > gate-out/semantics-b$batch-$round.txt 2>&1
  done
done
echo done > gate-out/DONE
