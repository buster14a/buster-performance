#!/bin/bash
# stages.sh TREE TAG: build TREE (with the stage marks), then benchmark-backend-source with BUSTER_TIER0_STAGES on tiny1 and tiny6, 3 rounds.
. ~/buster-fast-bench/2972-claude/env.sh
D=~/buster-fast-bench/2972-claude
cd $D
TREE=$1; TAG=$2
mkdir -p results/$TAG copies
(cd $TREE && $X timeout -k 5 1800 ./build.sh --config Release > $D/results/$TAG/build.log 2>&1) || { echo "build failed" >> results/$TAG/status.txt; exit 1; }
cp $TREE/build/compiler compiler-$TAG
for round in 1 2 3; do
  for f in tiny1 tiny6; do
    for o in vector scalar; do
      cp compiler-$TAG copies/run-$TAG
      BUSTER_TIER0_STAGES=$D/results/$TAG/stages-$f-$o-$round.txt $X timeout -k 5 300 taskset -c 2 ./copies/run-$TAG benchmark-backend-source --only $o inputs/$f.c > results/$TAG/$f-$o-$round.log 2>&1
      echo "$f $o $round exit $?" >> results/$TAG/status.txt
      rm -f copies/run-$TAG
    done
  done
done
echo done >> results/$TAG/status.txt
