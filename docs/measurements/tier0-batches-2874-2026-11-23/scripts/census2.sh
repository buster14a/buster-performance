#!/bin/bash
# census2.sh BINARY TAG GROUP LOOPS: the batch build's passes by event (buster#2874): benchmark-backend-source's vector
# variant on sqlite3.c, GROUP functions a batch (0: one at a time), a run a stop and an event pair. The caller holds the lock.
set -u
D=~/buster-fast-bench/2874-claude-volta
C=$D/corpus
BIN=$1; TAG=$2; GROUP=$3; LOOPS=${4:-41}
FLAGS="--predefines $C/provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include"
mkdir -p $D/results/$TAG
cd $D/results/$TAG
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-before.txt
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
for s in 5 6 8 9 -1; do
  for k in A1 A2 B1 B2 C1 C2 D1 D2 E1 E2 F1 F2 G1 G2 H1 H2 I1 I2; do
    line=$(BUSTER_TIER0_LOOPS=$LOOPS BUSTER_TIER0_STOP=$s BUSTER_TIER0_GROUP=$GROUP BUSTER_TIER0_EVENTS=${SETS[$k]} taskset -c 2 $BIN benchmark-backend-source --only vector $FLAGS $C/sqlite/sqlite3.c 2>&1 | grep '^census:')
    echo "set=$k $line" >> census.txt
  done
done
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; } > busy-after.txt
wc -l census.txt
