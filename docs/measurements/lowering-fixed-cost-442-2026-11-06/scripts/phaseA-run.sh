#!/bin/bash
cd ~/buster-fast-bench/442-claude-rebase
S=cts/tests/single-exec
F="$S/00001.c $S/00010.c $S/00050.c $S/00100.c $S/00150.c $S/00200.c $S/00210.c"
mkdir -p phaseA
for t in main418 pr418 now fix1 fix2; do
    taskset -c 2 trees/$t/build/compiler benchmark-emit-ab --passes 101 $F > phaseA/$t.txt 2>&1
done
many=$(for i in $(seq 100); do echo -n "$S/00001.c "; done)
for t in now fix2; do
    taskset -c 2 perf record -q -F 25000 -g -o phaseA/$t-00001.data trees/$t/build/compiler benchmark-emit-ab --passes 101 $many > phaseA/$t-perf.txt 2>&1
done
