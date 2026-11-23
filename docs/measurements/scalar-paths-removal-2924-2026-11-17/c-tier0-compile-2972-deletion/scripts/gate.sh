#!/bin/bash
# gate.sh TREE TAG: build TREE (with knob.patch), then the compile knob's ticks: twin (0x1) against vector (0), five rounds
# in turn, on objects.sh's corpora plus tiny.c, each run its own hold of the lock, CPU 2. Objects compared across masks.
. ~/buster-fast-bench/2972-claude/env.sh
D=~/buster-fast-bench/2972-claude
cd $D
TREE=$1; TAG=$2
R=$D/results/$TAG
mkdir -p $R/ticks copies
if [ ! -x compiler-$TAG ]; then
  (cd $TREE && $X timeout -k 5 1800 ./build.sh --config Release > $R/build.log 2>&1) || { echo "build failed" >> $R/status.txt; exit 1; }
  cp $TREE/build/compiler compiler-$TAG
fi
objects=/dev/shm/claude-2972-$TAG
for round in 1 2 3 4 5; do
  for mask in 0 0x1; do
    rm -f $R/ticks/$mask-$round.txt
    cp compiler-$TAG copies/gate-$TAG
    BUSTER_TIER0_SCALAR_AREAS=$mask BUSTER_TIER0_AREA_TICKS=$R/ticks/$mask-$round.txt $X timeout -k 5 1500 taskset -c 2 $D/objects.sh $D/copies/gate-$TAG $objects/$mask $D/$TREE > $R/ticks-$mask-$round.log 2>&1
    echo "ticks $mask $round: $(tr '\n' ' ' < $R/ticks-$mask-$round.log) $(wc -l < $R/ticks/$mask-$round.txt) lines" >> $R/status.txt
    rm -f copies/gate-$TAG
  done
  if [ $round = 1 ]; then
    (cd $objects && find 0 -name '*.o' | sort | while read f; do cmp -s "$f" "0x1/${f#0/}" && echo same || echo "DIFFER $f"; done | sort | uniq -c) > $R/objects.txt
  fi
  rm -rf $objects
done
echo done >> $R/status.txt
