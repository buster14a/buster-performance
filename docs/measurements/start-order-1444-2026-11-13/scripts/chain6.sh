#!/bin/sh
# The pull request's head (final2: the .bss change, the token columns and the start order) against main.
d=~/buster-fast-bench/1444-claude-rest
cd $d
. ./env.sh
while [ ! -f chain5.done ] || ! grep -q "^done" build-final2.log 2>/dev/null; do sleep 10; done
~/buster-fast-bench/exclusive.sh sh -c "head -1 /var/lib/buster-9700x/owner >> results/census-holds.txt; ./census2.sh final2 syntax preprocess tiny hello tinyfirst check parse"
./kstat.sh main2 base final2
./ab.sh main2 2 base final2
echo done > chain6.done
