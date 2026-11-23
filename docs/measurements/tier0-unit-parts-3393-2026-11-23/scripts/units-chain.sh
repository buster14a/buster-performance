#!/bin/bash
D=~/buster-fast-bench/3393-claude
until [ "$(grep -c exit $D/results/run-f1.log 2>/dev/null)" = 14 ]; do sleep 10; done
for b in main f1; do
  EXCLUSIVE_OWNER=claude-3393 EXCLUSIVE_TITLE="buster #3393 unit parts" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3393 ~/buster-fast-bench/exclusive.sh timeout -k 5 300 $D/scripts/units.sh $D/bin/$b units-$b 3
  echo "units $b exit $?"
done
