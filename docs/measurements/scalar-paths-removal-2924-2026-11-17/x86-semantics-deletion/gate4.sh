#!/bin/sh
# #2924 x86 semantics, second gate: main 68cc356a4 + knob2.diff (the batch knob, the opmask twin as the scalar path with
# BUSTER_GATE_OPMASKS=1, and the choice's small-count changes: quarters with no live request skipped, the candidate loop
# kept rolled and left once every live request is taken). One locked run at a time, after gate3.sh finishes.
set -u
cd ~/buster-fast-bench/2924-x86
. ./env.sh
while [ ! -f gate-out/DONE ]; do sleep 30; done
L=~/buster-fast-bench/exclusive.sh
if [ ! -d gate4 ]; then git clone -q --shared gate gate4 && git -C gate4 checkout -q --detach 68cc356a4 && git -C gate4 apply ../knob2.diff; fi
$L timeout -k 5 600 sh -c 'cd gate4 && ./build.sh --config Release' > gate4-build.log 2>&1 || { echo "build failed" > gate-out/gate4-failed; exit 1; }
cp gate4/build/compiler /dev/shm/x86gate4-compiler
C=/dev/shm/x86gate4-compiler
for batch in 1 2 8; do
  $L env BUSTER_GATE_BATCH=$batch timeout -k 5 300 taskset -c 2 $C benchmark-x86-semantics --requests 16384 --functions 512 > gate-out/g4-semantics-b$batch.txt 2>&1
done
$L env BUSTER_GATE_OPMASKS=1 BUSTER_GATE_BATCH=1 timeout -k 5 300 taskset -c 2 $C benchmark-x86-semantics --requests 4096 --functions 512 > gate-out/g4-opmasks-b1.txt 2>&1
echo done > gate-out/DONE4
