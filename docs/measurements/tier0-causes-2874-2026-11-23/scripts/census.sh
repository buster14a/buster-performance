#!/bin/bash
# census.sh BINARY TAG VARIANT LOOPS [STOPS]: benchmark-backend-source's VARIANT on sqlite3.c, CPU 2, LOOPS loops a
# run, a run a stop (BUSTER_TIER0_STOP) and an event set; each line the medians an entry (buster#2874). The caller holds
# the lock for the whole script: every run is under two seconds.
set -u
D=~/buster-fast-bench/2874-claude-volta
C=$D/corpus
BIN=$1; TAG=$2; VARIANT=$3; LOOPS=${4:-41}; STOPS=${5:-"0 1 2 3 4 5 6 7 8 9 10 11 -1"}
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
mkdir -p $D/results/$TAG
cd $D/results/$TAG
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-before.txt
# Event sets, two raw events each (umask << 8 | event; the event's bits 8 to 11 at bits 32 to 35): with the harness's
# cycles, instructions and throttle that is five counters, what the 9700X has free beside the NMI watchdog's, so that no
# event is multiplexed (seven events were: a short run read zeros).
#  A1: retired uops, mispredicted branches                A2: retired branches, store-to-load conflicts
#  B1: loads dispatched, stores dispatched                B2: store-to-load forwards, loads crossing a cache line
#  C1: demand fills of the data cache: all, from L2       C2: data-cache fills by any source, L1 DTLB misses
#  D1: uops from the decoder, from the op cache           D2: op cache misses, instruction cache misses
#  E1: slots with no uop from the front end, slots stalled by the back end
#  E2: cycles nothing retired: all, the oldest op waiting for a load
#  F1: microcoded uops retired, hardware prefetch fills   F2: dispatch stalls on the load queue, on the store queue
#  G1: cycles the op queue is empty, cycles nothing retired with the retire queue empty
#  G2: cycles nothing retired with the oldest op not executed, the predictor's redirects by mispredicts
#  H1: dispatch stalls on the FP scheduler, on integer physical registers
#  H2: dispatch stalls on the retire queue, branches the L2 BTB corrected
#  I1: 512-bit packed uops retired, 256-bit               I2: 128-bit, scalar FP
declare -A SETS
SETS[A1]="c1,c3";               SETS[A2]="c2,224"
SETS[B1]="129,229";             SETS[B2]="35,147"
SETS[C1]="ff43,143";            SETS[C2]="ff44,ff45"
SETS[D1]="1aa,2aa";             SETS[D2]="20000048f,10000188e"
SETS[E1]="1000001a0,100001ea0"; SETS[E2]="1bd6,a2d6"
SETS[F1]="1000000c2,df5a";      SETS[F2]="2ae,4ae"
SETS[G1]="a9,1d6";              SETS[G2]="2d6,29f"
SETS[H1]="40ae,1ae";            SETS[H2]="20af,8b"
SETS[I1]="2008,1008";           SETS[I2]="808,408"
: > census.txt
for s in $STOPS; do
  # The first stops' loops are short: more of them.
  n=$LOOPS; case $s in 0|1|2) n=$((LOOPS * 8));; esac
  for k in A1 A2 B1 B2 C1 C2 D1 D2 E1 E2 F1 F2 G1 G2 H1 H2 I1 I2; do
    line=$(BUSTER_TIER0_LOOPS=$n BUSTER_TIER0_STOP=$s BUSTER_TIER0_EVENTS=${SETS[$k]} taskset -c 2 $BIN benchmark-backend-source --only $VARIANT $FLAGS $C/sqlite/sqlite3.c 2>&1 | grep '^census:')
    echo "set=$k $line" >> census.txt
  done
done
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-after.txt
cat census.txt
