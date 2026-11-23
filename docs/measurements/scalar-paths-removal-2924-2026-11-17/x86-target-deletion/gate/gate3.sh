#!/bin/sh
# #2924 x86 tables' twins gate, trimmed for the shared queue: one locked run at a time, timeout inside the lock.
set -u
cd ~/buster-fast-bench/2924-x86
. ./env.sh
mkdir -p gate-out
cp gate/build/compiler /dev/shm/x86gate-compiler
C=/dev/shm/x86gate-compiler
L=~/buster-fast-bench/exclusive.sh
$L timeout -k 5 300 taskset -c 2 $C benchmark-x86-target > gate-out/target-1.txt 2>&1
for batch in 1 8 0; do
  $L env BUSTER_GATE_BATCH=$batch timeout -k 5 300 taskset -c 2 $C benchmark-x86-semantics --requests 16384 --functions 512 > gate-out/semantics-b$batch-1.txt 2>&1
done
$L timeout -k 5 300 taskset -c 2 $C benchmark-x86-target --after-predefines 200 > gate-out/target-after-1.txt 2>&1
echo done > gate-out/DONE
