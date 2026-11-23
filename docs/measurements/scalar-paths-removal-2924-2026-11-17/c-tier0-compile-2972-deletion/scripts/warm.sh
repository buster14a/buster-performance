#!/bin/bash
# warm.sh EXE TAG [ROUNDS]: benchmark-backend-source --only vector/scalar on tiny.c, tiny1.c, tiny6.c; CPU 2, under the lock.
. ~/buster-fast-bench/2972-claude/env.sh
D=~/buster-fast-bench/2972-claude
cd $D
EXE=$1; TAG=$2; R=${3:-3}
mkdir -p results/$TAG copies
for round in $(seq 1 $R); do
  for f in tiny tiny1 tiny6; do
    for o in vector scalar; do
      cp $EXE copies/run-$TAG
      $X timeout -k 5 300 taskset -c 2 ./copies/run-$TAG benchmark-backend-source --only $o inputs/$f.c > results/$TAG/$f-$o-$round.log 2>&1
      echo "$f $o $round exit $?" >> results/$TAG/status.txt
      rm -f copies/run-$TAG
    done
  done
done
echo done >> results/$TAG/status.txt
