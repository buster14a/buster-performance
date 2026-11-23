#!/bin/bash
# head.sh: the PR's head (main + the series): build, warm benchmark (the compile alone), objects against main's, and
# whole compiles against main's (time-runs, fresh copies). Each step its own hold of the lock, CPU 2.
. ~/buster-fast-bench/2972-claude/env.sh
D=~/buster-fast-bench/2972-claude
cd $D
R=$D/results/head
mkdir -p $R copies
if [ ! -x compiler-head ]; then
  (cd head && $X timeout -k 5 1800 ./build.sh --config Release > $R/build.log 2>&1) || { echo "build failed" >> $R/status.txt; exit 1; }
  cp head/build/compiler compiler-head
fi
echo "built $(cd head && git log --oneline -1)" >> $R/status.txt
for round in 1 2 3; do
  for f in tiny tiny1 tiny6; do
    cp compiler-head copies/run-head
    $X timeout -k 5 300 taskset -c 2 ./copies/run-head benchmark-backend-source --only vector inputs/$f.c > $R/$f-vector-$round.log 2>&1
    echo "$f vector $round exit $?" >> $R/status.txt
    rm -f copies/run-head
  done
done
# Objects: main's and head's, every corpus.
for t in main head; do
  rm -rf /dev/shm/claude-2972-objects-$t
  $X timeout -k 5 1500 taskset -c 2 ./objects.sh $D/compiler-$t /dev/shm/claude-2972-objects-$t $D/main > $R/objects-$t.log 2>&1
  echo "objects $t: $(tr '\n' ' ' < $R/objects-$t.log)" >> $R/status.txt
done
(cd /dev/shm/claude-2972-objects-main && find . -name '*.o' | sort | while read f; do cmp -s "$f" "/dev/shm/claude-2972-objects-head/$f" && echo same || echo "DIFFER $f"; done | sort | uniq -c) > $R/objects.txt
echo "objects compared: $(tr '\n' ' ' < $R/objects.txt)" >> $R/status.txt
rm -rf /dev/shm/claude-2972-objects-main /dev/shm/claude-2972-objects-head
echo done >> $R/status.txt
