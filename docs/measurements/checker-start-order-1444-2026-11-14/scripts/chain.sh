#!/bin/sh
# #1444, the checker's section: the campaign in order, each step its own holds of the 9700X's lock.
set -eu
d=~/buster-fast-bench/1444-claude-checker
cd $d
echo $$ > chain.pid
./build-tree.sh base 389d25b91a8bbc6faba040125be2ccad51b6815d
./build-tree.sh mid 9cb325741ceb42e61db8833c6624f6ddbc1ee0ec 389d25b91a8bbc6faba040125be2ccad51b6815d
./build-tree.sh head 9cb325741ceb42e61db8833c6624f6ddbc1ee0ec
mkdir -p results
for b in base mid head; do ./census.sh $b syntax preprocess tiny hello check parse; done
./ab.sh main 2 base mid head
./kstat.sh main base mid head
echo done > chain.done
