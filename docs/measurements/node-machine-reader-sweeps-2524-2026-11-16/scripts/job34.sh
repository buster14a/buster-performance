#!/bin/bash
# job34.sh: do the shadow's own sweeps' cycles follow the distance between the machine's structure (in the census's
# frame) and the sweeps' frames? u4 and w4 are u3 and w2 with phase.patch: BUSTER_STACK_PHASE moves the sweeps' frames
# down by that many bytes at run time. Built; then phase-o.sh, seven passes, 32 phases.
set -u
cd "$(dirname "$0")"
log=results/job34.log
cat u3.patch phase.patch > u4.patch
./build-label.sh u4 be6515fba u4.patch > results/u4-build.out 2>&1 || { echo "u4 build failed" >> $log; exit 1; }
./build-label.sh w4 be6515fba w4.patch > results/w4-build.out 2>&1 || { echo "w4 build failed" >> $log; exit 1; }
echo "built $(date -u +%T)" >> $log
./phase-o.sh a 7 u4 w4
python3 phase.py results a u4 w4 > results/phase-a-u4-w4.txt 2>&1
echo "job34 done $(date -u +%FT%TZ)" >> $log
