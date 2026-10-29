#!/bin/bash
W=$HOME/buster-fast-bench/units-152-claude
echo $$ > $W/after3.pid
while kill -0 $(cat $W/after2.pid) 2>/dev/null; do sleep 10; done
RUNS=5 $W/measure2.sh $W/exp/tree-final/build/compiler $W/final2 synth > $W/synth2.log 2>&1
echo synth2-finished >> $W/synth2.log
